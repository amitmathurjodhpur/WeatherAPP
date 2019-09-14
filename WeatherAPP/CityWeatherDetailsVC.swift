//
//  CityWeatherDetailsVC.swift
//  WeatherAPP
//
//  Created by Amit on 12/09/2019.
//  Copyright © 2018 Amit. All rights reserved.
//

import UIKit
import AVFoundation

class CityWeatherDetailsVC: UIViewController {
    var arrWeatherDetails = [WeatherResult]()
    var strWeatherTitle = String()
    var strWeatherDescription = String()
    var dt = Int()

    fileprivate var player: AVPlayer!
    fileprivate var assetManager: AssetManager!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var imgDayIcon: UIImageView!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        assetManager = AssetManager()
        appUtilities = AppUtilities()

        if arrWeatherDetails.count > 0 {
            let result = arrWeatherDetails[0]
            switch result
            {
            case .Error( _):
                lblWeatherDescription.text = ""
            case .Success(let conditions):
                var strWeatherInfo = String()
                imgDayIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(conditions.imagName).png"), placeholderImage: UIImage(named: ""))
                let formattedMinTemperature = String(format: "%.2f", conditions.Mintemperature)
                let formattedMaxTemperature = String(format: "%.2f", conditions.Maxtemperature)
                strWeatherInfo = strWeatherInfo.appending("Current Weather summary: \(conditions.generalDescription)")
                strWeatherInfo = strWeatherInfo.appending("\n\nMin temperature: \(formattedMinTemperature)℃")
                strWeatherInfo = strWeatherInfo.appending("\n\nMax temperature: \(formattedMaxTemperature)℃")
                strWeatherInfo = strWeatherInfo.appending("\n\nHumidity: \(conditions.humidityPercent)")
                strWeatherInfo = strWeatherInfo.appending("\n\nSpeed: \(conditions.objWeather["speed"] ?? "" as AnyObject)")
                strWeatherInfo = strWeatherInfo.appending("\n\nPressure: \(conditions.objWeather["pressure"] ?? "" as AnyObject)")
                strWeatherInfo = strWeatherInfo.appending("\n\nDeg: \(conditions.objWeather["deg"] ?? "" as AnyObject)")
                strWeatherInfo = strWeatherInfo.appending("\n\nClouds: \(conditions.objWeather["clouds"] ?? "" as AnyObject)")
                
                lblWeatherDescription.text = strWeatherInfo
            }
            
//            self.startVideoBackground(weatherVideo: self.assetManager.getWeatherCondition(weather: strWeatherDescription, hour: Int(appUtilities.getHour(timeInterval: dt))!))
        }
    }

    @IBAction func btnCancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Animations Methods
    @objc func viewDidBecomeActive() {
        if player != nil {
            appUtilities.videoAlwaysPlay(videoPlayer: player)
        }
    }
    
    func startVideoBackground(weatherVideo: AssetManager.WEATHER_VIDEO) {
        appUtilities.delay(second: 0.3) {
            UIView.animate(withDuration: 0.5, animations: {
                self.player = appUtilities.setVideoUIView(view: self.view, videoType: weatherVideo)
            })
            appUtilities.videoAlwaysPlay(videoPlayer: self.player)
            NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
