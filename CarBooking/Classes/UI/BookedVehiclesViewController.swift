//
//  BookedVehiclesViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookedVehiclesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshController: UIRefreshControl!
    
    var dataSource: [Booking] = []
    
    var request: Request?
    
    var showDetailTries = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        
        setupPullToRefresh()
        
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadIfNeeded()
        
        showDetailTries = 2
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
        
        layoutCollectionView()
    }
    
    func handle(database array: [Booking]?) {
        
        dataSource = array?.sorted { ($0.date?.timeIntervalSince1970 ?? 0) < ($1.date?.timeIntervalSince1970 ?? 0) } ?? []
        
        collectionView.reloadData()
        
        layoutCollectionView()
        
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
        
        layoutCollectionView()
    }
    
    func layoutCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = isPad ? view.frame.size.width / 3 : view.frame.size.width
        
        return CGSize(width: width, height: 100)
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
        
        guard let controller = segue.destination as? BookingDetailViewController else { return }
        
        guard let index = collectionView.indexPathsForSelectedItems?.first?.row else { return }
        
        controller.booking = dataSource[index]
    }
    
    @objc func showDetail(for id: Int) {
        
        showDetailTries -= 1
        
        guard showDetailTries >= 0 else { return }
        
        guard let item = dataSource.enumerated().first(where: { $0.element.id == id }) else {
            return perform(#selector(showDetail(for:)), with: id, afterDelay: 0.5)
        }
        
        let index = IndexPath(row: item.offset, section: 0)
        
        collectionView.selectItem(at: index, animated: false, scrollPosition: .centeredVertically)
        
        performSegue(withIdentifier: "showDetail", sender: collectionView)
    }
    
    deinit {
        request?.cancel()
    }
}

