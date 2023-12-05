//
//  Notifications.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import Foundation

extension Notification.Name {
    static let incorrectCityName = Notification.Name("incorrectCityName")
    static let emptyCityField = Notification.Name("emptyCityField")
    static let cityAlreadySaved = Notification.Name("cityAlreadySaved")
    static let citySaved = Notification.Name("citySaved")
}
