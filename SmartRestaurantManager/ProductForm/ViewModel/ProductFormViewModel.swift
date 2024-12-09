//
//  ProductFormViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import Foundation

class ProductFormViewModel {
    static let shared = ProductFormViewModel()
    @Published var product = ProductModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveProduct(productModel: product, completion: completion)
    }
    
    func clear() {
        product = ProductModel(id: UUID())
    }
}
