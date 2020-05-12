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
        verifyUserLocation()
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
           case .authorizedWhenInUse:
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.large
                loadingIndicator.startAnimating();
                alert.view.addSubview(loadingIndicator)
               present(alert, animated: true, completion: nil)
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
               self.temperature.text = weaterInfo.temperature + "°C"
               self.dismiss(animated: false, completion: nil)
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
