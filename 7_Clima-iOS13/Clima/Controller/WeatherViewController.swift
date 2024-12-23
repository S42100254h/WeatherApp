//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var jokeText: UITextView!
    
    //MARK: Properties
    var weatherManager = WeatherDataManager()
    var jokeManager = JokeDataManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchField.delegate = self
        jokeManager.delegate = self
    }
}
 
//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchField.endEditing(true)    //dismiss keyboard
        print(searchField.text!)
        
        searchWeather()
    }

    func searchWeather(){
        if let cityName = searchField.text{
            weatherManager.fetchWeather(cityName)
            print("action: serach, city: \(cityName)")
        }
    }
    
    // when keyboard return clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)    //dismiss keyboard
        print(searchField.text!)
        
        searchWeather()
        return true
    }
    
    // when textfield deselected
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false            // check if city name is valid
        }
    }
    
    // when textfield stop editing (keyboard dismissed)
    func textFieldDidEndEditing(_ textField: UITextField) {
//        searchField.text = ""   // clear textField
    }

    @IBAction func jokeBtnClicked(_ sender: UIButton) {
        jokeManager.fetchJoke()
    }
}

//MARK:- View update extension
extension WeatherViewController: JokeManagerDelegate, WeatherManagerDelegate {
    
    func updateWeather(weatherModel: WeatherModel){
        DispatchQueue.main.sync {
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            // 東京の場合のみ背景画像を変更
            let backgroundImageName = (cityLabel.text == "Tokyo") ? "tokyo" : "background"
            self.background.image = UIImage(named: backgroundImageName)
        }
    }
    
    func updateJoke(jokeModel: JokeModel) {
        DispatchQueue.main.sync {
            jokeText.text = jokeModel.joke
        }
    }

    func failedWithError(error: Error){
        print(error)
    }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

