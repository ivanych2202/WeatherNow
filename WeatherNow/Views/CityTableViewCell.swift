//
//  CityTableViewCell.swift
//  WeatherNow
//
//  Created by Ivan Elonov on 05.12.2023.
//

import Foundation

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    static let identifier = "CityTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CityTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
