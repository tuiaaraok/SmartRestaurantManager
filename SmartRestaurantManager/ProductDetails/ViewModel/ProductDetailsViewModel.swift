//
//  ProductFormViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

class ProductDetailsViewModel {
    static let shared = ProductDetailsViewModel()
    @Published var product: ProductModel?
    private init() {}
    
    func clear() {
        product = nil
    }
}
