//
//  EmployeeModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

struct EmployeeModel {
    var id: UUID
    var name: String?
    var position: Int?
    var startOfShift: Date?
    var endOfShift: Date?
    var datesOfShift: Date?
}
