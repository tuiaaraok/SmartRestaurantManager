//
//  MenuViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import Foundation

class MenuViewModel {
    static let shared = MenuViewModel()
    private var data: [ProductModel] = []
    @Published var products: [ProductModel] = []
    var selectedType: Int = 0
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchProducts { [weak self] products, _ in
            guard let self = self else { return }
            self.data = products
            self.filter(by: selectedType)
        }
    }
    
    func filter(by type: Int) {
        selectedType = type
        products = data.filter({ $0.category == selectedType })
    }
    
    func clear() {
        data = []
        products = []
        selectedType = 0
    }
}
