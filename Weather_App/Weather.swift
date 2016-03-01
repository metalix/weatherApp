//
//  Weather.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 24.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    private var _searchCity: String!
    private var _city: String!
    private var _country: String!
    private var _temp: Int!
    private var _pressure: Int!
    private var _humidity: Int!
    private var _windSpeed: Int!
    private var _windDirection: Int!
    private var _sunrise: Double!
    private var _sunset: Double!
    private var _icon: String!
    private var _weatherUrl: String!
    private var _daysIcon = [String]()
    
    let now = NSDate()
    
    var city: String {
        return _city
    }
    
    var country: String {
        return _country
    }
    
    var temp: Int {
        return _temp
    }
    
    var pressure: Int {
        return _pressure
    }
    
    var humidity: Int {
        return _humidity
    }
    
    var windSpeed: Int {
        return _windSpeed
    }
    
    var icon: String {
        return _icon
    }
    
    var daysIcon: [String] {
        return _daysIcon
    }
    
    init(city: String) {
        self._searchCity = city
        _weatherUrl = "\(URL_BASE)\(WEATHER_BASE)\(_searchCity)\(APPID)"
    }
    
    func getWindDirection() -> String {
        var dirString = ""
        let direction = _windDirection
        
        if direction >= 23 && direction <= 67 {
            dirString = "NE"
        } else if direction > 67 && direction <= 112 {
            dirString = "E"
        } else if direction > 112 && direction <= 157 {
            dirString = "SE"
        } else if direction > 157 && direction <= 202 {
            dirString = "S"
        } else if direction > 202 && direction <= 247 {
            dirString = "SW"
        } else if direction > 247 && direction <= 292 {
            dirString = "W"
        } else if direction > 292 && direction <= 337 {
            dirString = "NW"
        } else {
            dirString = "N"
        }
        
        return dirString
    }
    
    func getSunrise() -> String {
        return convertTime(self._sunrise)
    }
    
    func getSunset() -> String {
        return convertTime(self._sunset)
    }
    
    func convertTime(time: Double) -> String {
        let epocTime = NSTimeInterval(time)
        let myDate = NSDate(timeIntervalSince1970:  epocTime)
        return myDate.houres
    }
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _weatherUrl)
        Alamofire.request(.GET, url!).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                if let city = dict["name"] as? String {
                    self._city = city
                }
                
                if let sys = dict["sys"] as? Dictionary<String, AnyObject> {
                    if let country = sys["country"] as? String {
                        self._country = country
                    }
                    
                    if let sunrise = sys["sunrise"] as? Double {
                        self._sunrise = sunrise
                    }
                    
                    if let sunset = sys["sunset"] as? Double {
                        self._sunset = sunset
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Int {
                        self._temp = temp
                    }
                    
                    if let pressure = main["pressure"] as? Int {
                        self._pressure = pressure
                    }
                    if let humidity = main["humidity"] as? Int {
                        self._humidity = humidity
                    }
                }
                
                if let wind = dict["wind"] as? Dictionary<String, AnyObject>{
                    if let windSpeed = wind["speed"] as? Int {
                        self._windSpeed = windSpeed
                    }
                    
                    if let windDirection = wind["deg"] as? Int {
                        self._windDirection = windDirection
                    }
                }
                
                if let ico = dict["weather"] as? [Dictionary<String, AnyObject>] where ico.count > 0{
                    if let icon = ico[0]["icon"] as? String {
                       self._icon = icon
                    }
                }

                if let cityID = dict["id"] as? Int {
                    let forecastUrl = "\(URL_BASE)\(FORECAST_BASE)\(cityID)\(APPID)"
                    let url = NSURL(string: forecastUrl)
                    Alamofire.request(.GET, url!).responseJSON { response in
                        if let dict2 = response.result.value as? Dictionary<String, AnyObject>{
                            if let list = dict2["list"] as? [Dictionary<String, AnyObject>] where list.count > 0 {
                                let nowInt = Int(self.now.houresOnly)!
                                var startPoint = 0
                                let addFactor = 4
                                
                                if nowInt >= 21 {
                                    startPoint = 0
                                } else if (nowInt >= 18 && nowInt < 21) {
                                    startPoint = 1
                                } else if (nowInt >= 15 && nowInt < 18) {
                                    startPoint = 2
                                } else if (nowInt >= 12 && nowInt < 15) {
                                    startPoint = 3
                                } else if (nowInt >= 9 && nowInt < 12) {
                                    startPoint = 4
                                } else if (nowInt >= 6 && nowInt < 9) {
                                    startPoint = 5
                                } else if (nowInt >= 3 && nowInt < 6) {
                                    startPoint = 6
                                } else {
                                    startPoint = 7
                                }
                                
                                var j = 0
                                
                                for var i = startPoint; i <= (startPoint + addFactor * 6); i += addFactor {

                                    if let main = list[i]["main"] as? Dictionary<String, AnyObject> {
                                        if let temp = main["temp"] as? Double {
                                            graphPoints[j] = temp
                                            j++
                                        }
                                    }
                                    
                                    if (j + 2) % 2 == 0 {
                                        if let weather = list[i]["weather"] as? [Dictionary<String, AnyObject>] where weather.count > 0 {
                                            if let icon = weather[0]["icon"] as? String {
                                                self._daysIcon.append(icon)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                    completed()
                }
            }
        }
    }
}
}