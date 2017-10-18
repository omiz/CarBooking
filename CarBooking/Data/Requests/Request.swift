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

extension APIRequest {
    
    @discardableResult
    open func reload(success successBlock: ((Model) -> Void)? = nil,
                      failure failureBlock: ((APIError<ErrorModel>) -> Void)? = nil) -> Alamofire.DataRequest? {
        
        //TODO: add fitch from database
        return self.perform(withSuccess: successBlock, failure: failureBlock)
    }
}
