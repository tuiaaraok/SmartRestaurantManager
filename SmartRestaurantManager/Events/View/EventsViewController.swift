//
//  EventsViewController.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit
import FSCalendar
import Combine

class EventsViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var eventsTableView: UITableView!
    private let viewModel = EventsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationMenuButton()
        setNavigationTitle(title: "Scheduled Events")
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.appearance.eventDefaultColor = .baseGreen
        calendarView.appearance.eventSelectionColor = .baseGreen
        eventsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.eventsTableView.reloadData()
                self.calendarView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openEventForm() {
        let eventFormVC = EventFormViewController(nibName: "EventFormViewController", bundle: nil)
        eventFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(eventFormVC, animated: true)
    }
    
    @IBAction func clickedAdd(_ sender: UIButton) {
        openEventForm()
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.configure(event: viewModel.events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventFormViewModel.shared.event = viewModel.events[indexPath.row]
        openEventForm()
    }
}

extension EventsViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if viewModel.events.contains(where: { $0.date == date.stripTime() }) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        false
    }
}
