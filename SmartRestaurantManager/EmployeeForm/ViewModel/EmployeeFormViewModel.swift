//
//  EmployeeFormViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

class EmployeeFormViewModel {
    static let shared = EmployeeFormViewModel()
    @Published var employee = EmployeeModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveEmployee(employeeModel: employee, completion: completion)
    }
    
    func clear() {
        employee = EmployeeModel(id: UUID())
    }
}
