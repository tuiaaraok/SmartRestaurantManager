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
    private var search: String?
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchProducts { [weak self] products, _ in
            guard let self = self else { return }
            self.data = products
            self.filter(by: selectedType)
        }
    }
    
    func remove(by id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeProduct(by: id, completion: completion)
    }
    
    func search(by value: String?) {
        self.search = value
        filter(by: selectedType)
    }
    
    func filter(by type: Int) {
        let trimmedSearch = search?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        selectedType = type
        products = data.filter { product in
            let matchesType = selectedType == 0 || product.category == selectedType
            let matchesSearch = trimmedSearch == nil || trimmedSearch!.isEmpty || (product.name?.lowercased().contains(trimmedSearch!)) ?? false
            return matchesType && matchesSearch
        }
    }
    
    func clear() {
        data = []
        products = []
        selectedType = 0
        search = nil
    }
}
