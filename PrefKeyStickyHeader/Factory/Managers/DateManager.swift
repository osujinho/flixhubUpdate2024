//
//  DateManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/30/23.
//

import Foundation

//final class DataManager {
//    
//    static let shared = DataManager()
//    
//    private init() { }
//    
//    // string to date
//    func getDate(date: String?, forMonthAndYear: Bool) -> String {
//        guard let date = date else { return GlobalValues.defaultWrappedString }
//        
//        let oldDateFormatter = DateFormatter()
//        oldDateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        // Convert string to date
//        guard let oldDate = oldDateFormatter.date(from: date) else { return GlobalValues.defaultWrappedString }
//        
//        // convert date back to string in year format
//        let newDateFormater = DateFormatter()
//        newDateFormater.dateFormat = forMonthAndYear ? "MMM yyyy" : "dd MMM yyyy"
//        
//        return newDateFormater.string(from: oldDate)
//    }
//    
//    func minutesToHours(minutes: Int?) -> String {
//        if let minutes = minutes {
//            let hours = minutes / 60
//            let remainingMinutes = minutes % 60
//            return "\(hours)h \(remainingMinutes)m"
//        }
//        return GlobalValues.defaultWrappedString
//    }
//
//    // get death date in string
//    func getDeathdate(date: String?) -> String {
//        guard let date = date else { return "Alive" }
//        
//        let oldDateFormatter = DateFormatter()
//        oldDateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        // Convert string to date
//        guard let oldDate = oldDateFormatter.date(from: date) else { return GlobalValues.defaultWrappedString }
//        
//        // convert date back to string in year format
//        let newDateFormater = DateFormatter()
//        newDateFormater.dateFormat = "dd MMM yyyy"
//        
//        return newDateFormater.string(from: oldDate)
//    }
//
//    // Get age in strings
//    func getAge(birthDate: String?) -> String {
//        guard let birthDate = birthDate else { return GlobalValues.defaultWrappedString }
//        
//        let birthdayFormat = DateFormatter()
//        birthdayFormat.dateFormat = "yyyy-MM-dd"
//        
//        guard let birthdayDate = birthdayFormat.date(from: birthDate) else {  return GlobalValues.defaultWrappedString}
//        
//        let today = Date()
//        let calender = Calendar.current
//        
//        let ageComponents = calender.dateComponents([.year], from: birthdayDate, to: today)
//        guard let age = ageComponents.year else { return GlobalValues.defaultWrappedString }
//        return String(age) + " years"
//    }
//    
//    // get Age in Int
//    func getAgeNumber(birthDate: String?) -> Int {
//        
//        guard let birthDate = birthDate else { return Int.max }
//        
//        let birthdayFormat = DateFormatter()
//        birthdayFormat.dateFormat = "yyyy-MM-dd"
//        
//        guard let birthdayDate = birthdayFormat.date(from: birthDate) else {  return Int.max}
//        
//        let today = Date()
//        let calender = Calendar.current
//        
//        let ageComponents = calender.dateComponents([.year], from: birthdayDate, to: today)
//        guard let age = ageComponents.year else { return Int.max }
//        return age
//    }
//
//    // string to time
//    func stringToTime(strTime: Int?) -> String {
//        guard let strTime = strTime else { return GlobalValues.defaultWrappedString }
//        let totalMinutes = Double(strTime)
//        
//        let hours = Int(floor(totalMinutes / 60))
//        let minutes = Int(totalMinutes) % 60
//        
//        return "\(hours)h \(minutes)mins"
//    }
//    
//    func unwrapNumbersToString(_ number: Int?) -> String {
//        guard let number = number else { return GlobalValues.defaultWrappedString }
//        return String(number)
//    }
//
//    func getGender(genderNumber: Int?) -> String {
//        guard let genderNumber = genderNumber else {
//            return "Not Specified"
//        }
//        
//        switch genderNumber {
//        case _ where genderNumber == 1: return "Female"
//        case _ where genderNumber == 2: return "Male"
//        case _ where genderNumber == 3: return "Non-Binary"
//        default: return "Not Specified"
//        }
//    }
//
//    func getLanguage(code: String?) -> String {
//        guard let languageCode = code else { return GlobalValues.defaultWrappedString}
//        
//        let usLocale = Locale(identifier: "en-US")
//        if let languageName = usLocale.localizedString(forLanguageCode: languageCode) {
//            return languageName
//        }
//        return GlobalValues.defaultWrappedString
//    }
//
//    func getCountry(countryCode: String) -> String {
//        let usLocale = Locale(identifier: "en-US")
//        if let countryName = usLocale.localizedString(forRegionCode: countryCode) {
//            return countryName
//        }
//        return GlobalValues.defaultWrappedString
//    }
//
//    func getMoney(amount: Int?) -> String {
//        guard let amount = amount else { return GlobalValues.defaultWrappedString }
//        if amount <= 0 { return GlobalValues.defaultWrappedString }
//        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.maximumFractionDigits = 0
//        if let stringAmount = formatter.string(from: NSNumber(value: amount)) {
//            return stringAmount
//        }
//        return GlobalValues.defaultWrappedString
//    }
//}
