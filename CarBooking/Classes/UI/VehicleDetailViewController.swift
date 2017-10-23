//
//  VehicleDetailViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class VehicleDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containtView: UIView!
    @IBOutlet weak var containtStackView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var BookButton: UIButton!
    
    @IBOutlet var headerConstraint: NSLayoutConstraint!
    
    var vehicleId: Int?
    
    var vehicle: VehicleDetail?
    
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        
        setupImageViewHeight()
        
        updateContentBottom()
        
        updateViewContent()
        
        loadIfNeeded()
    }
    
    func prepareView() {
        
        navigationItem.title = "Vehicle".localized
        
        nameLabel.adjustsFontSizeToFitWidth = true
        shortDescriptionLabel.adjustsFontSizeToFitWidth = true
        
        buttonsView.layer.cornerRadius = cornerRadius
        buttonsView.backgroundColor = .primary
        
        BookButton.setTitle("Book".localized, for: .normal)
        
        BookButton.layer.cornerRadius = cornerRadius
    }
    
    func setupImageViewHeight() {
        headerConstraint.isActive = false
        
        view.layoutIfNeeded()
        view.layoutSubviews()
        
        headerConstraint.isActive = true
        
        headerConstraint.constant = imageView.frame.size.height
        
        setContentTop()
    }
    
    func setContentTop(animated: Bool = false) {
        
        scrollView.contentInset.top = imageView.frame.size.height
        
        scrollView.contentOffset = CGPoint(x: 0, y: -imageView.frame.size.height)
        
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.scrollView.layoutIfNeeded()
        })
    }
    
    func updateContentBottom() {
        
        let bottom = view.frame.height - buttonsView.frame.origin.y
        
        scrollView.contentInset.bottom = bottom
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        request?.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        request?.suspend()
    }
    
    func loadIfNeeded() {
        guard vehicle == nil else { return }
        
        load()
    }
    
    func load() {
        
        guard let id = vehicleId else { return }
        
        request?.cancel()
        
        request = DataManager.shared.vehicles.detail(for: id).load(success: {
            self.handleResponse($0)
            self.stopReloadProccess()
        }, failure: { _ in
            self.alertFailure()
            self.stopReloadProccess()
        })
    }
    
    func handleResponse(_ vehicle: VehicleDetail) {
        self.vehicle = vehicle
        
        updateViewContent()
    }
    
    func updateViewContent() {
        
        imageView.load(vehicle?.image)
        
        nameLabel.text = vehicle?.name
        
        shortDescriptionLabel.text = vehicle?.shortDescription
        
        descriptionLabel.text = vehicle?.vehicleDescription
    }
    
    func stopReloadProccess() {
        
    }
    
    func alertFailure() {
        
        updateViewContent()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        headerConstraint.constant = max(-offset.y, 0)
        
        view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        
        setupDetailIndexIfNeeded(in: segue)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard vehicle != nil else { return false }
        
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    func setupDetailIndexIfNeeded(in segue: UIStoryboardSegue) {
        
        guard let navigationController = segue.destination as? UINavigationController else { return }
        
        guard let controller = navigationController.viewControllers.first as? BookingDateViewController else { return }
        
        controller.vehicle = vehicle
    }

    deinit {
        request?.cancel()
    }

}
