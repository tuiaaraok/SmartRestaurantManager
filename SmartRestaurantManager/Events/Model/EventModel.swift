//
//  EventModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

struct EventModel {
    var id: UUID
    var name: String?
    var numberGuests: Int?
    var date: Date?
    var startTime: Date?
    var endTime: Date?
}
