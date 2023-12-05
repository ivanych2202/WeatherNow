//
//  DataManager.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import UIKit
import CoreData

class DataManager: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedData: [City] = []
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            fetchedData = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    
    func saveCity(cityName: String) {
        
        let attributeName = "name"
        let attributeValue = cityName
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", attributeName, attributeValue)
        
        do {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            if let objects = objects, !objects.isEmpty {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .cityAlreadySaved, object: nil, userInfo: ["cityName": cityName])
                }
            } else {
                let city = City(context: context)
                city.name = cityName
                
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .citySaved, object: nil, userInfo: ["cityName": cityName])
                    }
                } catch {
                    fatalError("Unable to save the city: \(error)")
                }
            }
        } catch {
            print("Error fetching city: \(error)")
        }
    }
    
    
    
    func deleteSavedCity(cityName: String) {
        
        let attributeName = "name"
        let attributeValue = cityName
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", attributeName, attributeValue)
        
        do {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for object in objects ?? [] {
                context.delete(object)
            }
            try context.save()
            print("Successfully deleted object(s).")
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
        
}
