//
//  EmployeesViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

class EmployeesViewModel {
    static let shared = EmployeesViewModel()
    private var data: [EmployeeModel] = []
    @Published var employees: [EmployeeModel] = []
    var selectedPosition: Int = 0
    var selectedDate: Date = Date().stripTime()
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchEmployees { [weak self] employees, _ in
            guard let self = self else { return }
            self.data = employees
            choosePosition(position: selectedPosition)
        }
    }
    
    func filter() {
        if selectedPosition == 0 {
            employees = data.filter({ $0.datesOfShift == selectedDate })
        } else {
            employees = data.filter({ $0.position == selectedPosition && $0.datesOfShift == selectedDate })
        }
    }
    
    func choosePosition(position: Int) {
        self.selectedPosition = position
        filter()
    }
    
    func chooseDate(date: Date) {
        selectedDate = date
        filter()
    }
    
    func clear() {
        data = []
        employees = []
        selectedPosition = 0
        selectedDate = Date().stripTime()
    }
}
