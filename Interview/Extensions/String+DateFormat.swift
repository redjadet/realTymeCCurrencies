//
//  String+DateFormat.swift
//  Interview
//
//  Created by ilker sevim on 2.02.2022.
//

import Foundation

extension String{
    
    func convertDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this is current string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let convertedDate = dateFormatter.date(from: self)

        guard dateFormatter.date(from: self) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"///this is what i want to convert
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
}
