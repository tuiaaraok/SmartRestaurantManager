//
//  Date.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let formattedDate = dateFormatter.string(from: self)
        let day = Calendar.current.component(.day, from: self)
        let dayWithSuffix = dayWithOrdinalSuffix(day: day)
        return formattedDate.replacingOccurrences(of: "\(day)", with: dayWithSuffix)
    }
    
    private func dayWithOrdinalSuffix(day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "\(day)th"
        default:
            switch day % 10 {
            case 1:
                return "\(day)st"
            case 2:
                return "\(day)nd"
            case 3:
                return "\(day)rd"
            default:
                return "\(day)th"
            }
        }
    }
    
    func stripTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    func settingCurrentTime() -> Date? {
        let calendar = Calendar.current
        let currentTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
        return calendar.date(bySettingHour: currentTimeComponents.hour!,
                             minute: currentTimeComponents.minute!,
                             second: currentTimeComponents.second!,
                             of: self)
    }
    
    func getTodayAt(hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(from: components)
    }
    
    func daysDifference(to toDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: toDate)
        if let days = components.day {
            return days + 1
        }
        return 0
    }
}
