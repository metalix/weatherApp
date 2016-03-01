//
//  ViewController.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 20.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import UIKit

var graphPoints: [Double] = [0.4, 5.2, 4, 6, 3.6, 4.6, 2.6]

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var detailView: DetailView!
    @IBOutlet weak var forecastGraphView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windDirSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var mainIconImg: UIImageView!
    @IBOutlet weak var day1Label: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day1Icon: UIImageView!
    @IBOutlet weak var day2Icon: UIImageView!
    @IBOutlet weak var day3Icon: UIImageView!
    
    let now = NSDate()
    var isDetailViewShowing = false
    var currentCity = "Warsaw"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        addData()
    }
    
    func addData() {
        let weather = Weather(city: currentCity)
        self.day1Label.text = now.dateByAddingTimeInterval(60*60*24*1).weekDayShort
        self.day2Label.text = now.dateByAddingTimeInterval(60*60*24*2).weekDayShort
        self.day3Label.text = now.dateByAddingTimeInterval(60*60*24*3).weekDayShort
        
        weather.downloadWeatherDetails { () -> () in
            self.cityLabel.text = weather.city
            self.countryLabel.text = weather.country
            let date = NSDate()
            self.dateLabel.text = date.monthDay
            self.dayLabel.text = date.weekDay
            self.tempLabel.text = "\(weather.temp)"
            self.windDirSpeedLabel.text = "\(weather.getWindDirection()) \(weather.windSpeed) m/s"
            self.humidityLabel.text = "\(weather.humidity) %"
            self.pressureLabel.text = "\(weather.pressure) hPa"
            self.sunriseLabel.text = "\(weather.getSunrise())"
            self.sunsetLabel.text = "\(weather.getSunset())"
            self.mainIconImg.image = UIImage(named: "\(weather.icon).png")
            if weather.daysIcon.count > 0 {
                self.day1Icon.image = UIImage(named: "\(weather.daysIcon[0]).png")
                self.day2Icon.image = UIImage(named: "\(weather.daysIcon[1]).png")
                self.day3Icon.image = UIImage(named: "\(weather.daysIcon[2]).png")
            }
            self.graphView.setNeedsDisplay()
        }
    }
    
    @IBAction func detailViewBtnPressed(sender: AnyObject) {
        
        if (isDetailViewShowing) {
            
            //hide Detail View
            UIView.transitionFromView(detailView,
                toView: forecastGraphView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft.union(UIViewAnimationOptions.ShowHideTransitionViews),
                completion:nil)
        } else {
            UIView.transitionFromView(forecastGraphView,
                toView: detailView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft.union(UIViewAnimationOptions.ShowHideTransitionViews),
                completion: nil)

        }
       isDetailViewShowing = !isDetailViewShowing
        
    }
 
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        currentCity = searchBar.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        addData()
    }

}