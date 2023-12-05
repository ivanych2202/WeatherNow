//
//  ViewController.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import UIKit
import AudioToolbox

protocol MenuListControllerDelegate: AnyObject {
    func didCitySelect(cityName: String)
}

class ViewController: UIViewController, UITextFieldDelegate, MenuListControllerDelegate {
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherStateImage: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var searchCityTextField: UITextField!
    
    let weatherManager = WeatherManager()
    let dataManager = DataManager()
    let locationManager = LocationManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentLocation()

        searchCityTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(cityNameIsIncorrect), name: .incorrectCityName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cityFieildIsEmpty), name: .emptyCityField, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cityAlreadySaved), name: .cityAlreadySaved, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(citySaved), name: .citySaved, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func cityNameIsIncorrect() {
        showAlert(withMessage: "The city you entered does not match any known location.", withTitle: "Oops!")    }
    
    @objc func cityFieildIsEmpty() {
        showAlert(withMessage: "You do not enter the city name.", withTitle: "Sorry.")
    }
    
    @objc func cityAlreadySaved(notification: Notification) {
        if let cityName = notification.userInfo?["cityName"] as? String {
            showAlert(withMessage: "\(cityName) is already saved.", withTitle: "")
        }
    }
    
    @objc func citySaved(notification: Notification) {
        if let cityName = notification.userInfo?["cityName"] as? String {
            showAlert(withMessage: "\(cityName) has been saved.", withTitle: "")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func didCitySelect(cityName: String) {
        playSystemSound(soundId: 1104)
        getWeather(cityName: cityName)
    }
    
    func showAlert(withMessage message: String, withTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func playSystemSound(soundId: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(soundId))
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        playSystemSound(soundId: 1104)
        
        if searchCityTextField.text != "" {
            let cityName = searchCityTextField.text
            getWeather(cityName: cityName)
            self.view.endEditing(true)
        } else {
            NotificationCenter.default.post(name: .emptyCityField, object: nil)
            getCurrentLocation()
        }
        
        
    }
    
    
    @IBAction func menuButtonPressed() {
        
        playSystemSound(soundId: 1306)
        
        let destinationVC = MenuListController()
        destinationVC.delegate = self
        
        present(destinationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func saveCityButtonPressed(_ sender: UIButton) {
        
        playSystemSound(soundId: 1104)
        
        if searchCityTextField.text != "" {
            let cityName = searchCityTextField.text
            
            getWeather(cityName: cityName )
            dataManager.saveCity(cityName: cityName!)
            
        } else {
            NotificationCenter.default.post(name: .emptyCityField, object: nil)
            getCurrentLocation()
        }
    }
    
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        playSystemSound(soundId: 1306)
        getCurrentLocation()
        
    }
    
    func getCurrentLocation() {
        locationManager.startUpdatingLocation { [weak self] coordinate in
            guard let coordinate = coordinate else {
                return
            }
            
            self?.getWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        }
    }
    
    
    
    func getWeather(cityName: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        weatherManager.getWeather(cityName: cityName, latitude: latitude, longitude: longitude) { cityName, temperature, weatherState in
            guard let cityName = cityName, let temperature = temperature, let weatherState = weatherState else {
                return
            }
            self.updateUI(with: cityName, temperature: temperature, weatherState: weatherState)
        }
    }
    
    
    func updateUI(with cityName: String, temperature: Int, weatherState: String) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName
            self.temperatureLabel.text = "\(temperature)°"
            self.weatherStateImage.image = UIImage(systemName: self.getWeatherStateImageName(weatherState))
        }
    }
    
    
    func getWeatherStateImageName(_ weatherState: String) -> String {
        
        switch weatherState {
        case "Clouds":
            "cloud.fill"
        case "Thunderstorm":
            "cloud.bolt.rain.fill"
        case "Drizzle":
            "cloud.drizzle.fill"
        case "Rain":
            "cloud.heavyrain.fill"
        case "Clear":
            "sun.max.fill"
        case "Snow":
            "snowflake.circle.fill"
        default:
            "smoke.fill"
        }
        
    }
    
    
}


