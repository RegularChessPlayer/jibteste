//
//  ViewController.swift
//  WheaterApp
//
//  Created by Thiago Rodrigues on 10/05/20.
//  Copyright © 2020 Thiago Souza. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    lazy var managerLocation = CLLocationManager()
    
    var weatherAPi: OpenWeatherApi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerLocation.delegate = self
        managerLocation.requestLocation()
    }
    
    @IBAction func nextCities(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueCities", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCities" {
            let citiesViewController = segue.destination as? CitiesViewController
            citiesViewController?.openWeaterApi = weatherAPi
        }
    }
    
    func verifyUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined:
               managerLocation.requestWhenInUseAuthorization()
               break
           default:
               break
           }
        }
    }
        
    func getCurrentTemperature() {
        weatherAPi?.getCurrentTemperaturePosition { (weaterInfo) in
               self.city.text = weaterInfo.city
               self.temperature.text = weaterInfo.temperature
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            weatherAPi = OpenWeatherApi(lat: "\(location.coordinate.latitude)",
                                        lng: "\(location.coordinate.longitude)")
            getCurrentTemperature()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
