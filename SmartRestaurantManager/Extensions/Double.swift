//
//  Double.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import Foundation

extension Double? {
    func formattedToString() -> String {
        guard let self = self else { return "" }
        if Double(Int(self)) == self {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    func formattedToString() -> String {
        if Double(Int(self)) == self {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}
