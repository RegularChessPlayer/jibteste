//
//  CitiesViewController.swift
//  WheaterApp
//
//  Created by Thiago Rodrigues on 11/05/20.
//  Copyright © 2020 Thiago Souza. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var citiesInfo: Array<WeaterInfo> = []
    var openWeaterApi: OpenWeatherApi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let openWeaterApi = self.openWeaterApi{
            openWeaterApi.listCurrentTemperatureNextCities { (weaterInfos) in
                let treatInfos = weaterInfos.dropFirst()
                let sortInfos = treatInfos.sorted(by: { Double($0.temperature) ?? 0 > Double($1.temperature) ?? 0 })
                self.citiesInfo = sortInfos
                self.tableView.reloadData()
            }
        }else{
            print("Failed to get current position")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCity", for: indexPath) as! CitiesTableViewCell
        cell.city.text = citiesInfo[indexPath.row].city
        cell.temperature.text = citiesInfo[indexPath.row].temperature  + "°C"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
