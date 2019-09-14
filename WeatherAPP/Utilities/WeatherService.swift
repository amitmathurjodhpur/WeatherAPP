//
//  WeatherService.swift
//  WeatherAPP
//
//  Created by Amit on 12/09/2019.
//  Copyright © 2018 Amit. All rights reserved.
//

import Foundation
import Alamofire

struct WeatherConditions {
    var city: String
    var temperatureCelsius: Double
    var humidityPercent: Int
    var generalDescription: String
    var Mintemperature: Double
    var Maxtemperature: Double
    var dt: Int
    var imagName: String
    var objWeather: [String: AnyObject]
}

enum WeatherResult {
    case Success(WeatherConditions)
    case Error(String)
}

fileprivate let API_KEY = "51174bce8f4a02feb1551c3b7485e95a"
fileprivate let BASE_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
public let IMAGE_URL = "http://openweathermap.org/img/w"
class WeatherService {
    
    func weather(forCity city: String, completionHandler: @escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        let escapedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(BASE_URL)?q=\(escapedCity)&mode=json&units=metric&cnt=16&appid=\(API_KEY)")!
        
        Alamofire.request(url).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    if let json = response.result.value {
                        let dictemp = json as! NSDictionary
                        completionHandler(dictemp as! Dictionary<String, AnyObject>)
                    }
                } else {
                     failed("\(response.result.error?.localizedDescription ?? "")")
                }
            case .failure(_):
                failed("\(response.result.error?.localizedDescription ?? "")")
                break
            }
        }

       /* let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.Error(error.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(.Error("No data received"))
                return
            }
            completionHandler(self.weather(forCity: city, fromJsonData: data))
        }
        task.resume()*/
    }
    
    func weather(forCity city: String, raw :[String: AnyObject]) -> WeatherResult {
        var temperature:Double?
        var Mintemperature:Double?
        var Maxtemperature:Double?
        var description:String?
        var imageName:String?

        if let weather = raw["weather"] as? [AnyObject] {
            if let descriptionObj = weather[0] as? [String: AnyObject] {
                description = descriptionObj["description"] as? String
                imageName = descriptionObj["icon"] as? String
            }
        }
        let dt = raw["dt"] as? Int
        let humidity = raw["humidity"] as? Int

        if let main = raw["temp"] {
            temperature = main["day"] as? Double
            Mintemperature = main["min"] as? Double
            Maxtemperature = main["max"] as? Double
        }

        return .Success(WeatherConditions(city: city,
                                          temperatureCelsius: temperature!,
                                          humidityPercent: humidity!,
                                          generalDescription: description!,
                                          Mintemperature :Mintemperature!,
                                          Maxtemperature :Maxtemperature!,
                                          dt: dt!, imagName: imageName!, objWeather: raw))
    }
    
}
