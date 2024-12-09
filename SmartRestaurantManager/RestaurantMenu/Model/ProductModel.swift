//
//  ProductModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import Foundation

struct ProductModel {
    var id: UUID
    var name: String?
    var price: String?
    var category: Int?
    var info: String?
    var rating: Double = 0
    var photo: Data?
}
