//
//  WeatherManager.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import Foundation

class WeatherManager {
    
    func getWeather(cityName: String? = nil, latitude: Double? = nil, longitude: Double? = nil, dataCompletionHandler: @escaping (String?, Int?, String?) -> Void) {
        
        let appid: String = ""//paste your openweathermap api here"
        
        var urlString = ""
        
        if let latitude = latitude, let longitude = longitude {
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appid)&units=metric"
            
        } else {
            
            if let cityName = cityName, let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=\(appid)&units=metric"
            }
            
        }
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    dataCompletionHandler(nil,nil,nil)
                    return
                }
                if let data = data {
                    
                    parseJson(weatherData: data)
                }
                
            }
            task.resume()
            
        }
        
        
        func parseJson(weatherData: Data) {
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                
                let cityName = decodedData.name
                let temperature = Int(decodedData.main.temp)
                let weatherState = decodedData.weather[0].main
                
                dataCompletionHandler(cityName, temperature, weatherState)
                
            } catch {
                print("Error decoding weather data: \(error)")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .incorrectCityName, object: nil)
                }
            }
        }
    }
    
}
