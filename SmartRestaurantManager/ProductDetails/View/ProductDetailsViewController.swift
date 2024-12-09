//
//  ProductDetailsViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit
import Cosmos
import Combine

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private let viewModel = ProductDetailsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Product details")
        setNavigationBackButton()
        nameLabel.font = .semibold(size: 24)
        priceLabel.font = .semibold(size: 17)
        descriptionLabel.font = .regular(size: 20)
        subscribe()
    }
    
    func subscribe() {
        viewModel.$product
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                guard let self = self, let product = product else { return }
                if let data = product.photo {
                    self.photoImageView.image = UIImage(data: data)
                } else {
                    self.photoImageView.image = nil
                }
                nameLabel.text = product.name
                cosmosView.rating = product.rating
                priceLabel.text = "$\(product.price ?? "")"
                descriptionLabel.text = product.info
            }
            .store(in: &cancellables)
    }
    
    deinit {
        viewModel.clear()
    }
}
