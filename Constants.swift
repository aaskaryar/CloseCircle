//
//  Constants.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/17/22.
//

import SwiftUI
import FirebaseStorage


struct Constants {
    static let Home = "Home"
    static let Profile = "Profile"
    static let Capture = "Capture"
    static let accept = "Accepted"
    static let refused = "Refused"
    static let pending = "Pending"
    static let Public = "Public"
    static let Private = "Private"
    static let Own = "Invite Only"
    static let width = UIScreen.main.bounds.width
    
    static let DATABASE_COMMENTS = "Comments"
    
    
    static let NOTIFICATION_POST = "Post"
    static let NOTIFICATION_COMMENT = "Comment"
    static let NOTIFICATION_FOLLOW = "Follow"
    static let NOTIFICATION_Tagged = "Tagged"
    
    static let secondsInDay : Double = 86400.0
    
    static let DEFAULT_WEBPICTURE = "https://firebasestorage.googleapis.com:443/v0/b/shade-inc.appspot.com/o/profile_Photos%2F44PS79bJfWhmSsND6d6QSjBVPLm1?alt=media&token=c097a398-2c08-4d01-a3c9-14bc8337075b"
    static let DEFAULT_HOBBYPIC = "https://firebasestorage.googleapis.com/v0/b/shade-inc.appspot.com/o/default.jpg?alt=media&token=d70bfdc3-46ac-4744-912b-8e29e08eebdc"

    static let ShadeTeal: Color = Color(red: 91 / 255, green: 192 / 255, blue: 204 / 255) // teal company background
    static let ShadeGreen = Color.teal
    
    static let ShadeGray = Color(hex: 0xE4E7EC)
    ///These are some list of hobbies Aria
    static let names = ["art","coding","cooking","music","puzzles","reading","running","ski","surfing","swimming","training","travel"]
    static let textBG: Color = Color(red: 220 / 255, green: 221 / 255, blue: 226 / 255) // gray text background
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return ""
    }
}
