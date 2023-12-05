//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: TempMain
    let weather: [StateMain]
}

struct TempMain: Decodable {
    let temp: Double
}

struct StateMain: Decodable {
    let main: String
}
