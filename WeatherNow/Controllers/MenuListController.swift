//
//  MenuListController.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import Foundation

import UIKit

class MenuListController: UITableViewController {
    
    var dataManager: DataManager!
    
weak var delegate: MenuListControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = DataManager()
        dataManager.fetchData()
        
        tableView.reloadData()
        tableView.register(CityTableViewCell.nib(), forCellReuseIdentifier: CityTableViewCell.identifier)
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.backgroundColor = UIColor.white
        
        if let presentationController = presentationController as? UISheetPresentationController {
               presentationController.detents = [
                   .medium(),
                   .large()
               ]
            presentationController.prefersGrabberVisible = true

           }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.fetchedData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        
        let dataItem = dataManager.fetchedData[indexPath.row]
        cell.cityNameLabel.text = dataItem.name
        cell.backgroundColor = UIColor.white
        cell.cityNameLabel.textColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCity = dataManager.fetchedData[indexPath.row].name!
        delegate?.didCitySelect(cityName: selectedCity)
        dismiss(animated: true, completion: nil)
        
    }
    
     override func setEditing(_ editing: Bool, animated: Bool) {
         super.setEditing(editing, animated: animated)
         tableView.setEditing(editing, animated: animated)
     }
     
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             let selectedCity = dataManager.fetchedData[indexPath.row].name!
             dataManager.deleteSavedCity(cityName: selectedCity)
             dismiss(animated: true, completion: nil)
         }
     }
    
}
