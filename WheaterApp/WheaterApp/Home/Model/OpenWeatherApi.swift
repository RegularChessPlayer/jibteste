//
//  OpenWeatherApi.swift
//  WheaterApp
//
//  Created by Thiago Rodrigues on 10/05/20.
//  Copyright © 2020 Thiago Souza. All rights reserved.
//
import Foundation

class OpenWeatherApi: NSObject {
    
    let lat: String
    let lng: String

    init(lat: String, lng: String){
        self.lat = lat
        self.lng = lng
    }
    
    func getCurrentTemperaturePosition(sucess:@escaping(_ weatherInfo:WeaterInfo) -> Void){
        let mockWheaterApi = WeaterInfo(lat: "123", lng: "15", temperature: "30°C", city: "Fortaleza-CE")
        let second: Double = 1000000
        usleep(useconds_t(0.002 * second))
        sucess(mockWheaterApi)
    }
}
