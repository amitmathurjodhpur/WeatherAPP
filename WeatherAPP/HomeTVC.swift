//
//  HomeTVC.swift
//  WeatherAPP
//
//  Created by Amit on 12/09/2019.
//  Copyright © 2018 Amit. All rights reserved.
//

import UIKit

class HomeTVC: UITableViewController {
    private var results = [WeatherResult]()
    @IBOutlet weak var tblWeather: UITableView!
    var timerWeatherInfo: Timer?
    var collapseDetailViewController: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.arrCityPlaceID.add("Philadelphia")
        self.title = "Weather"
        self.tblWeather.estimatedRowHeight = 200
        self.tblWeather.rowHeight = UITableView.automaticDimension
        showProgress(inView: self.view)
        results.removeAll()
        self.getWeather()
    }

    //MARK : Get WeatherData
    func getWeather() {
        for i in 0..<appDelegate.arrCityPlaceID.count {
            WeatherService().weather(forCity: appDelegate.arrCityPlaceID[i] as! String, completionHandler: { (response) in
                 print(response)
                if let arrData = response["list"] as? NSArray {
                    for i in 0...arrData.count - 1 {
                        if let temp = arrData[i] as? [String: AnyObject] {
                            self.results.append(WeatherService().weather(forCity: "Philadelphia", raw: temp))
                        }
                    }
                }
                self.tblWeather.reloadData()
                hideProgress()
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tblWeather.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                    self.performSegue(withIdentifier: "mySegueID", sender: nil)
                }
            })
            { (responseError) in
                let alert = UIAlertController(title: "Error", message: "An error occurred while fetching weather information.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tblWeather.reloadData()
                hideProgress()
            }
        }
    }
   
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Button Actions
    @IBAction func refreshData() {
        showProgress(inView: self.view)
        results.removeAll()
        self.getWeather()
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
extension HomeTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
        let result = results[indexPath.row]
        switch result {
        case .Error(let error):
            cell.lblCityName.text = error
            cell.lblTemperature.text = ""
        case .Success(let conditions):
            let formattedTemperature = String(format: "%.2f", conditions.temperatureCelsius)
            cell.lblCityName.text = "Humidity: \(conditions.humidityPercent)"
            cell.lblTemperature.text = "\(formattedTemperature)℃"
            cell.lblDescription.text = "\(conditions.generalDescription)"
            cell.imgDayIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(conditions.imagName).png"), placeholderImage: UIImage(named: ""))
        }
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.collapseDetailViewController = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? CityWeatherDetailsVC
            else {
                fatalError()
        }
        
        viewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        viewController.navigationItem.leftItemsSupplementBackButton = true
        
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            let result = results[selectedRowIndexPath.row]
            switch result
            {
            case .Error( _):
                break
            case .Success(let conditions):
                viewController.arrWeatherDetails.append(result)
                viewController.strWeatherTitle = conditions.city
                viewController.strWeatherDescription = conditions.generalDescription
                viewController.dt = conditions.dt
            }
        }
    }
}

class WeatherInfoCell: UITableViewCell {
    @IBOutlet weak var lblCityName : UILabel!
    @IBOutlet weak var lblTemperature : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var imgDayIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
