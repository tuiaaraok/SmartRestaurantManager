//
//  EventsViewModel.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import Foundation

class EventsViewModel {
    static let shared = EventsViewModel()
    @Published var events: [EventModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchEvents { [weak self] events, _ in
            guard let self = self else { return }
            self.events = events
        }
    }
    
    func clear() {
        events = []
    }
}
