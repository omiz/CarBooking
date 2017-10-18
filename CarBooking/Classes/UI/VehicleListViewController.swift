//
//  VehicleListViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class VehicleListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshController: UIRefreshControl!
    
    var dataSource: [Vehicle] = []
    
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        
        setupPullToRefresh()
        
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        request?.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        request?.suspend()
    }
    
    func setupTitle() {
        navigationItem.title = "Vehicles".localized
    }
    
    func setupPullToRefresh() {
        refreshController = UIRefreshControl()
        refreshController?.addTarget(self, action: #selector(refreshChangedValue(_:)), for: .valueChanged)
        
        collectionView.addSubview(refreshController)
    }
    
    @objc func refreshChangedValue(_ sender: UIRefreshControl) {
        loadItems()
    }
    
    func loadItems() {
        request?.cancel()
        
        refreshController?.beginRefreshing()
        
        request = DataManager.shared.vehicles.all().reload(success: {
            self.handleResponse($0.array)
            self.stopReloadProccess()
        }, failure: { _ in
            self.alertFailure()
            self.stopReloadProccess()
        })
    }
    
    func handleResponse(_ array: [Vehicle]) {
        dataSource = array
        collectionView.reloadData()
    }
    
    func stopReloadProccess() {
        refreshController?.endRefreshing()
    }
    
    func alertFailure() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    
    //MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.size
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.cell(VehicleCollectionViewCell.self, for: indexPath)
        
        let item = dataSource[indexPath.row]
        
        cell.setup(item)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    deinit {
        request?.cancel()
    }
}

