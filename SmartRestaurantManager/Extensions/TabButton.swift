//
//  TabButton.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

class TabButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .white : .clear
        }
    }
    
    func commonInit() {
        self.titleLabel?.font = .medium(size: 18)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.black, for: .selected)
        self.backgroundColor = .clear
        self.roundCorners([.topLeft, .bottomLeft], radius: 24)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
