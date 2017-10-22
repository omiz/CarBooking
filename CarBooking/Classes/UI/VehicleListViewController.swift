//
//  VehicleListViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class VehicleListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var noteLabel: UILabel!
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
        noteLabel.text = ""
        
        request = DataManager.shared.vehicles.all().loadArray(success: {
            self.handle(success: $0.array)
            self.stopReloadProccess()
        }, failure: { _ in
            self.alertFailure()
            self.stopReloadProccess()
        })
    }
    
    func handle(success array: [Vehicle]) {
        
        dataSource = array.sorted { $0.name < $1.name }
        
        noteLabel.text = array.isEmpty ? "The Vehicle list will be shown here when available" : ""
        
        collectionView.reloadData()
    }
    
    func stopReloadProccess() {
        refreshController?.endRefreshing()
    }
    
    func alertFailure() {
        noteLabel.text = "Could not load because of an error \nPlease check your internet connection"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    
    //MARK: - collectionView
    
    //TODO: update vehicle cell size depending on the screen size
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        
        setupDetailIndexIfNeeded(in: segue)
    }
    
    func setupDetailIndexIfNeeded(in segue: UIStoryboardSegue) {
        
        guard let controller = segue.destination as? VehicleDetailViewController else { return }
        
        guard let index = collectionView.indexPathsForSelectedItems?.first?.row else { return }
        
        controller.vehicleId = dataSource[index].id
    }
    
    deinit {
        request?.cancel()
    }
}

