//
//  ViewController.swift
//  WheaterApp
//
//  Created by Thiago Rodrigues on 10/05/20.
//  Copyright © 2020 Thiago Souza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!

    let weatherAPi = OpenWeatherApi(lat: "139", lng: "33")

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPi.getCurrentTemperaturePosition { (weaterInfo) in
            self.city.text = weaterInfo.city
            self.temperature.text = weaterInfo.temperature
        }
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
    
}

