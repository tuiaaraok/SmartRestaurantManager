//
//  EventTableViewCell.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var guestsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.font = .bold(size: 36)
        dateTitleLabel.font = .medium(size: 24)
        nameLabel.font = .bold(size: 16)
        timeLabel.font = .light(size: 18)
        guestsLabel.font = .light(size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(event: EventModel) {
        let date = event.date?.toString(format: "dd MMM")
        let parts = date?.split(separator: " ")
        if let parts = parts, parts.count >= 2 {
            dateLabel.text = String(parts[0])
            dateTitleLabel.text = String(parts[1])
        }
        nameLabel.text = event.name
        timeLabel.text = "\(event.startTime?.toString(format: "HH:mm") ?? "") - \(event.endTime?.toString(format: "HH:mm") ?? "")"
        guestsLabel.text = "\(event.numberGuests ?? 0) guests"
    }
    
}
