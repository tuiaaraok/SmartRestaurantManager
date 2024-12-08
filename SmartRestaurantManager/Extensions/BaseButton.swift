//
//  BaseButton.swift
//  Party
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? self.backgroundColor?.withAlphaComponent(1) : self.backgroundColor?.withAlphaComponent(0.5)
        }
    }
    
    override var isSelected: Bool {
        didSet {
//            self.backgroundColor = isSelected ? .button : .baseGray
            let color = isSelected ? UIColor.white : .black
            self.setTitleColor(color, for: .normal)
        }
    }
    
    func commonInit() {
        self.titleLabel?.font = .medium(size: 22)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .black
        self.layer.cornerRadius = 12
        self.addShadow()
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
