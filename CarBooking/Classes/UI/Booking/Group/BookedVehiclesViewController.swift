//
//  BookedVehiclesViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

enum BookingFilters: String {
    case noFilter = "No filter"
    case active = "Active"
    case inactive = "Inactive"
    case today = "Today"
    
    static var count: Int { return BookingFilters.today.hashValue + 1}
    
    static var allValues: [BookingFilters] { return [noFilter, active, inactive, today] }
}

class BookedVehiclesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterPickerView: UIPickerView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    
    var refreshController: UIRefreshControl!
    
    var filtersDataSource: [BookingFilters] = BookingFilters.allValues
    
    var activeFilter: BookingFilters = .noFilter
    
    var originalDataSource: [Booking] = [] { didSet { filterDataSourceIfNeeded() } }
    
    var dataSource: [Booking] = []
    
    var request: Request?
    
    var showDetailTries = 2
    
    var rightBarButtonItems: [UIBarButtonItem] {
        return [UIBarButtonItem(image: UIImage(named: "barButton_filter"),
                                style: .plain,
                                target: self,
                                action: #selector(toggleFiltersView(_:)))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
        
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
        
        originalDataSource = array.sorted { ($0.date?.timeIntervalSince1970 ?? 0) < ($1.date?.timeIntervalSince1970 ?? 0) }
        
        noteLabel.text = array.isEmpty ? "The Booking list will be shown here when available".localized : ""
        
        collectionView.reloadData()
        
        layoutCollectionView()
    }
    
    func handle(database array: [Booking]?) {
        
        originalDataSource = array?.sorted { ($0.date?.timeIntervalSince1970 ?? 0) < ($1.date?.timeIntervalSince1970 ?? 0) } ?? []
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filtersDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filtersDataSource[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeFilter = filtersDataSource[row]
        
        filterDataSourceIfNeeded()
        
        collectionView.reloadData()
        
        toggleFiltersView(pickerView)
    }
    
    @objc func toggleFiltersView(_ sender: Any) {
        let show = filterViewHeightConstraint.constant == 0
        
        filterViewHeightConstraint.constant = show ? 200 : 0
        
        collectionView.isUserInteractionEnabled = !show
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func filterDataSourceIfNeeded() {
        switch activeFilter {
        case .noFilter:
            dataSource = originalDataSource
        case .active:
            dataSource = originalDataSource.filter({ ($0.date?.timeIntervalSinceNow ?? 0) > 0 })
        case .inactive:
            dataSource = originalDataSource.filter({ ($0.date?.timeIntervalSinceNow ?? 0) <= 0 })
        case .today:
            dataSource = originalDataSource.filter({ $0.date != nil && Calendar.current.isDateInToday($0.date!) })
        }
    }
    
    deinit {
        request?.cancel()
    }
}

