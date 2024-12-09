//
//  EmployeeTableViewCell.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startTimeLabel.font = .medium(size: 16)
        endTimeLabel.font = .medium(size: 16)
        positionLabel.font = .bold(size: 16)
        nameLabel.font = .light(size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(employee: EmployeeModel) {
        startTimeLabel.text = employee.startOfShift?.toString(format: "HH:mm")
        endTimeLabel.text = employee.endOfShift?.toString(format: "HH:mm")
        if let position = employee.position {
            positionLabel.text = EmployeePosition.allCases[position].rawValue
        } else {
            positionLabel.text = nil
        }
        nameLabel.text = employee.name
    }
    
}
