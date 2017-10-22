//
//  BookedVehiclesViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookedVehiclesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshController: UIRefreshControl!
    
    var dataSource: [Booking] = []
    
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        
        setupPullToRefresh()
        
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadIfNeeded()
    }
    
    func loadIfNeeded() {
        
        if request?.isSuspended ?? false {
            request?.resume()
            return
        }
        
        loadItems()
    }
    
    func setupTitle() {
        navigationItem.title = "My Bookings".localized
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
        
        request = DataManager.shared.bookings.all().loadArray(success: {
            self.handle(success: $0.array)
            self.stopReloadProccess()
        }, failure: { _ in
            self.alertFailure()
            self.stopReloadProccess()
        }, database: {
            self.handle(database: $0)
        })
    }
    
    func handle(success array: [Booking]) {
        
        dataSource = array.sorted { ($0.date?.timeIntervalSince1970 ?? 0) < ($1.date?.timeIntervalSince1970 ?? 0) }
        
        noteLabel.text = array.isEmpty ? "The Booking list will be shown here when available".localized : ""
        
        collectionView.reloadData()
    }
    
    func handle(database array: [Booking]?) {
        
        dataSource = array?.sorted { ($0.date?.timeIntervalSince1970 ?? 0) < ($1.date?.timeIntervalSince1970 ?? 0) } ?? []
        
        collectionView.reloadData()
        
        handleEmpty()
    }
    
    func handleEmpty() {
        guard dataSource.isEmpty else { return }
        
        noteLabel.text = "Your bookings will be shown here.".localized
    }
    
    func stopReloadProccess() {
        refreshController?.endRefreshing()
    }
    
    func alertFailure() {
        stopReloadProccess()
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
        
        let cell = collectionView.cell(BookingDetailCell.self, for: indexPath)
        
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

