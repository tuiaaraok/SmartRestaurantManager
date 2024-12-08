//
//  ProductTypeCollectionViewCell.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

class ProductTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .baseGreen : .baseGray
            nameLabel.textColor = isSelected ? .white : .black
//            nameLabel.font = isSelected ? .semibold(size: 16) : .regular(size: 16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .baseGray
        self.layer.cornerRadius = 12
        nameLabel.font = .regular(size: 16)
    }

    func configure(name: String?) {
        nameLabel.text = name
    }
    
}
