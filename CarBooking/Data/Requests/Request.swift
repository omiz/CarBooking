//
//  Request.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import Alamofire
import TRON

fileprivate var requestObject: UInt8 = 0
fileprivate var requestObjectId: UInt8 = 1

protocol Request {
    
    var isSuspended: Bool { get }
    
    func suspend()
    
    func resume()
    
    func cancel()
    
    var progress: Progress { get }
}


extension DataRequest: Request {
    var isSuspended: Bool {
        return self.delegate.queue.isSuspended
    }
}

typealias JSONEquatableCodable = Equatable & NSCoding & BaseObject
typealias JSONArrayEquatableCodable = JSONDecodableArray & JSONEquatableCodable


extension APIRequest where Model: JSONEquatableCodable {
    
    var object: Model? {
        get { return objc_getAssociatedObject(self, &requestObject) as? Model }
        set { objc_setAssociatedObject(self, &requestObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var objectId: Int? {
        get { return objc_getAssociatedObject(self, &requestObjectId) as? Int }
        set { objc_setAssociatedObject(self, &requestObjectId, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var dataKey: String { return typeName(Model.self) }
    
    @discardableResult
    func load(success successBlock: ((Model) -> Void)? = nil,
                      failure failureBlock: ((APIError<ErrorModel>) -> Void)? = nil,
                      database dateBaseBlock: ((Model?) -> Void)? = nil) -> Alamofire.DataRequest? {
        
        handle(database: dateBaseBlock)
        
        //TODO: add fitch from database
        return self.perform(withSuccess: successBlock, failure: failureBlock)
    }
    
    func handle(database dateBaseBlock: ((Model?) -> Void)? = nil) {
        
        DispatchQueue.global(qos: .background).async {
            let result: Model?
            switch self.method {
            case .get:
                result = self.fitch()
            case .post:
                result = self.push(self.object)
            case .put:
                result = self.put(self.object)
            case .delete:
                result = self.delete(self.objectId)
            default:
                result = nil
            }
            
            DispatchQueue.main.async {
                dateBaseBlock?(result)
            }
        }
    }
    
    func fitch() -> Model? {
        return fitchAll()?.first(where: { $0.id == objectId })
    }
    
    func fitchAll() -> [Model]? {
        guard let data = UserDefaults.standard.data(forKey: dataKey) else { return nil }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Model]
    }
    
    @discardableResult
    func push(_ model: Model?) -> Model? {
        
        guard var model = object else { return nil }
        
        var objects = fitchAll() ?? []
        
        let lastId = objects.last?.id ?? 0
        
        model.id = lastId + 1
        
        objects.append(model)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objects)
        UserDefaults.standard.set(encodedData, forKey: dataKey)
        UserDefaults.standard.synchronize()
        
        return object
    }
    
    @discardableResult
    func put(_ model: Model?) -> Model? {
        
        guard var model = object else { return nil }
        
        deleteIfNeeded(model.id)
        
        var objects = fitchAll() ?? []
        
        objects.append(model)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objects)
        UserDefaults.standard.set(encodedData, forKey: dataKey)
        UserDefaults.standard.synchronize()
        
        return object
    }
    
    func deleteIfNeeded(_ objectId: Int?) {
        
        var objects = fitchAll() ?? []
        
        guard let index = objects.index(where: { $0.id == objectId }) else { return }
        
        objects.remove(at: index)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objects)
        UserDefaults.standard.set(encodedData, forKey: dataKey)
        UserDefaults.standard.synchronize()
    }
    
    @discardableResult
    func delete(_ objectId: Int?) -> Model? {
        
        deleteIfNeeded(objectId)
        
        return object
    }
}

extension APIRequest where Model: JSONArrayEquatableCodable, Model.Element: JSONEquatableCodable {
    
    var objects: [Model.Element]? {
        get { return objc_getAssociatedObject(self, &requestObject) as? [Model.Element] }
        set { objc_setAssociatedObject(self, &requestObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var objectIds: [Int]? {
        get { return objc_getAssociatedObject(self, &requestObjectId) as? [Int] }
        set { objc_setAssociatedObject(self, &requestObjectId, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var dataKey: String { return typeName(Model.Element.self) }
    
    @discardableResult
    func loadArray(success successBlock: ((Model) -> Void)? = nil,
              failure failureBlock: ((APIError<ErrorModel>) -> Void)? = nil,
              database dateBaseBlock: (([Model.Element]?) -> Void)? = nil) -> Alamofire.DataRequest? {
        
        handleArray(database: dateBaseBlock)
        
        return self.perform(withSuccess: successBlock, failure: failureBlock)
    }
    
    //TODO: add fitch from database
    func handleArray(database dateBaseBlock: (([Model.Element]?) -> Void)? = nil) {
        
        DispatchQueue.global(qos: .background).async {
            let result: [Model.Element]?
            switch self.method {
            case .get:
                result = self.fitchArray()
            case .post:
                result = self.pushArray()
            case .put:
                result = self.pushArray()
            case .delete:
                result = self.deleteArray()
            default:
                result = nil
            }
            
            DispatchQueue.main.async {
                dateBaseBlock?(result)
            }
        }
    }
    
    func fitchArray() -> [Model.Element]? {
        guard let data = UserDefaults.standard.data(forKey: dataKey) else { return nil }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Model.Element]
    }
    
    @discardableResult
    func pushArray() -> [Model.Element]? {
        
        guard var objects = objects else { return nil }
        
        let storedObjects = fitchArray() ?? []
        
        let lastId = storedObjects.last?.id ?? 0
    
        objects.enumerated().forEach { objects[$0.offset].id = lastId + $0.offset }
        
        objects.append(contentsOf: storedObjects)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objects)
        UserDefaults.standard.set(encodedData, forKey: typeName(Model.Element.self))
        UserDefaults.standard.synchronize()
        
        return objects
    }
    
    @discardableResult
    func putArray() -> [Model.Element]? {
        
        guard let objects = objects else { return nil }
        
        var storedObjects = fitchArray() ?? []
        
        storedObjects = storedObjects.filter({ !objects.contains($0) })
        
        var lastId = storedObjects.last?.id ?? 0
        
        lastId += 1
        
        var new = objects.filter({ !storedObjects.contains($0) })
        
        new.enumerated().forEach { new[$0.offset].id = lastId + $0.offset }
        
        new.append(contentsOf: storedObjects)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: new)
        UserDefaults.standard.set(encodedData, forKey: typeName(Model.Element.self))
        UserDefaults.standard.synchronize()
        
        return objects
    }
    
    @discardableResult
    func deleteArray() -> [Model.Element]? {
        
        deleteIfNeeded()
        
        return objects
    }
    
    func deleteIfNeeded() {
        
        guard let ids = objectIds else { return }
        
        guard var objects = fitchAll() else { return }
        
        objects = objects.filter({ ids.contains($0.id) })
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: objects)
        UserDefaults.standard.set(encodedData, forKey: dataKey)
        UserDefaults.standard.synchronize()
    }
}
