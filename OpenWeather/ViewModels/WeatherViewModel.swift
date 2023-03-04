//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import Foundation
import UIKit

class WeatherViewModel {
    let name: String?
    let headline: String?
    let description: String?
    let detail1: String?
    let detail2: String?
    let detail3: String?
    var icon: UIImage?
    
    init(name: String? = nil,
         headline: String? = nil,
         description: String? = nil,
         detail1: Double? = nil,
         detail2: Double? = nil,
         detail3: Double? = nil,
         icon: UIImage? = nil){
        self.name = name ?? "--"
        self.headline = headline ?? "--"
        self.description = description
        self.icon = icon
        
        if let detail1 = detail1 {
            self.detail1 = "Temp = \(String(format: "%.2f", detail1))° F"
        } else {
            self.detail1 = nil
        }
        
        if let detail2 = detail2 {
            self.detail2 = "Min = \(String(format: "%.2f", detail2))° F"
        } else {
            self.detail2 = nil
        }
        
        if let detail3 = detail3 {
            self.detail3 = "Max = \(String(format: "%.2f", detail3))° F"
        } else {
            self.detail3 = nil
        }
    }
}
