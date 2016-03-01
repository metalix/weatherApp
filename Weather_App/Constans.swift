//
//  Constans.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 24.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import Foundation

let URL_BASE = "http://api.openweathermap.org/data/2.5/"
let WEATHER_BASE = "weather?q="
let FORECAST_BASE = "forecast?id="
let APPID = "&units=metric&APPID=ae7f6b626166a00aacd7326ea4ba11cd"

typealias DownloadComplete = () -> ()

extension NSDate {
    var monthDay: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM, dd"
        return dateFormatter.stringFromDate(self)
    }
    var weekDay: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(self)
    }
    var weekDayShort: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.stringFromDate(self).uppercaseString
    }
    
    var houres: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    var houresOnly: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.stringFromDate(self)
    }
}