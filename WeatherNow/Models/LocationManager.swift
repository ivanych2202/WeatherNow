//
//  LocationManager.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    private var locationUpdateCompletion: ((CLLocationCoordinate2D?) -> Void)?
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                completion(nil)
                return
            }
        }

        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }

        locationUpdateCompletion = completion
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        } else {
            locationUpdateCompletion?(nil)
        }
    }

    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        locationUpdateCompletion?(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print( error.localizedDescription)
    }
}
