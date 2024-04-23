//
//  GlobalMethods.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/23/24.
//

import SwiftUI

enum GlobalMethods {
    
    // MARK: - For Views
    static func collapsedNavBarHeight(safeAreaInsets: EdgeInsets) -> CGFloat {
        let safeTop = safeAreaInsets.top
        if safeTop > 0 {
            return max (safeTop + 25, 88)
        } else {
            return 50
        }
    }
    
    static func makeColor(red: Double, green: Double, blue: Double) -> Color {
        Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }
    
    // MARK: - For dates
    
    static func formatDate(_ dateString: String?, fullDate: Bool = false) -> String {
        guard let dateString = dateString else { return GlobalValues.defaultWrappedString }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return GlobalValues.defaultWrappedString }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        if fullDate {
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            if let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: currentDate),
               date >= threeMonthsAgo {
                dateFormatter.dateFormat = "dd MMM yyyy"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "MMM yyyy"
                return dateFormatter.string(from: date)
            }
        }
    }
    
    // For ISO timeStamp
    static func formatTimestamp(_ timestamp: String?) -> String {
        
        let defaultDate = "Invalid Date"
        guard let timestamp = timestamp else { return defaultDate }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = dateFormatter.date(from: timestamp) {
            let calendar = Calendar.current
            let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            
            if date > sevenDaysAgo {
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .abbreviated
                formatter.dateTimeStyle = .numeric
                return formatter.localizedString(for: date, relativeTo: Date())
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                return formatter.string(from: date)
            }
        } else {
            return defaultDate
        }
    }
    
    static func getDatefromISO(_ timestamp: String?) -> Date? {
        guard let timestamp = timestamp else { return nil }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return dateFormatter.date(from: timestamp)
    }
    
    // MARK: - Age
    
    // Get age in strings
    static func getAge(birthDate: String?, deathDate: String? = nil) -> String {
        guard let birthDate = birthDate else { return GlobalValues.defaultWrappedString }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let birthdayDate = dateFormatter.date(from: birthDate) else { return GlobalValues.defaultWrappedString }
        
        let endDate = deathDate.flatMap { dateFormatter.date(from: $0) } ?? Date()
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdayDate, to: endDate)
        
        guard let age = ageComponents.year else { return GlobalValues.defaultWrappedString }
        return "\(age) years"
    }
    
    // string to time
    static func formatRuntime(strTime: Int?) -> String {
        guard let strTime = strTime else { return GlobalValues.defaultWrappedString }
        let totalMinutes = Double(strTime)
        
        if totalMinutes < 60 {
            return "\(Int(totalMinutes))m"
        } else {
            let hours = Int(floor(totalMinutes / 60))
            let minutes = Int(totalMinutes) % 60
            return "\(hours)h \(minutes)m"
        }
    }

    // MARK: - Gender
    
    static func formatGender(genderNumber: Int?) -> String {
        guard let genderNumber = genderNumber else {
            return "Not Specified"
        }
        
        switch genderNumber {
        case _ where genderNumber == 1: return "Female"
        case _ where genderNumber == 2: return "Male"
        case _ where genderNumber == 3: return "Non-Binary"
        default: return "Not Specified"
        }
    }
    
    // MARK: - Language and Country
    static func formatLanguage(code: String?) -> String {
        guard let languageCode = code else { return GlobalValues.defaultWrappedString}
        
        let usLocale = Locale(identifier: "en-US")
        if let languageName = usLocale.localizedString(forLanguageCode: languageCode) {
            return languageName
        }
        return GlobalValues.defaultWrappedString
    }

    static func formatCountry(countryCode: String) -> String {
        let usLocale = Locale(identifier: "en-US")
        if let countryName = usLocale.localizedString(forRegionCode: countryCode) {
            return countryName
        }
        return GlobalValues.defaultWrappedString
    }

    // MARK: - Money and Awards
    
    static func formatMoney(amount: Int?) -> String {
        guard let amount = amount else { return GlobalValues.defaultWrappedString }
        if amount <= 0 { return GlobalValues.defaultWrappedString }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let stringAmount = formatter.string(from: NSNumber(value: amount)) {
            return stringAmount
        }
        return GlobalValues.defaultWrappedString
    }
    
    static func formatAwards(awards: String?) -> [String]? {
        awards?.components(separatedBy: ". ")
    }
    
    // MARK: - For Collections
    
    static func getArrayString(contents: [String]?) -> String {
        if let contents = contents, !contents.isEmpty {
            return contents.joined(separator: "\n")
        }
        return GlobalValues.defaultWrappedString
    }
}
