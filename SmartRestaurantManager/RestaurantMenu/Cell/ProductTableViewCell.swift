//
//  ProductTableViewCell.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit
import Cosmos

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.masksToBounds = true
        nameLabel.font = .medium(size: 17)
        priceLabel.font = .medium(size: 17)
    }
    
    func configure(product: ProductModel) {
        if let data = product.photo {
            photoImageView.image = UIImage(data: data)
        } else {
            photoImageView.image = nil
        }
        nameLabel.text = product.name
        priceLabel.text = "$ \(product.price ?? "")"
        cosmosView.rating = product.rating
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
