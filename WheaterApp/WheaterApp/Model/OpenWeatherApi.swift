//
//  OpenWeatherApi.swift
//  WheaterApp
//
//  Created by Thiago Rodrigues on 10/05/20.
//  Copyright © 2020 Thiago Souza. All rights reserved.
//
import Foundation
import Alamofire

class OpenWeatherApi: NSObject {
    
    let lat: String
    let lng: String
    let APIKEY = "1a0a246b29a30dbc534d250e27cface2"
    let BASE_GET = "https://api.openweathermap.org/data/2.5/weather"
    let BASE_LIST = "https://api.openweathermap.org/data/2.5/"

    init(lat:String, lng:String){
        self.lat = lat
        self.lng = lng
    }
    
    func getCurrentTemperaturePosition(sucess:@escaping(_ weatherInfo:WeaterInfo) -> Void ){
        let QUERYPARAMS: String = "?lat=\(lat)&lon=\(lng)&appid=\(APIKEY)&units=metric"
        AF.request(BASE_GET + QUERYPARAMS, method: .get).responseJSON { response in
            switch response.result {
            case .success:
            do{
              guard let dictResponse = try response.result.get() as? Dictionary<String, Any>,
                    let coord = dictResponse["coord"] as? Dictionary<String, Any>,let lat = coord["lat"] as? Double,
                    let lon = coord["lon"] as? Double, let main = dictResponse["main"] as? Dictionary<String, Any>, let temp = main["temp"] as? Double, let city = dictResponse["name"] as? String else{
                        print("Erro ao desserializar response")
                        return
                    }
                let mockWheaterApi = WeaterInfo(lat: String(lat), lng: String(lon), temperature: String(temp), city: city)
                sucess(mockWheaterApi)
            }catch{
                print("Erro ao desserializar info")
            }
            case .failure:
                print(response.error!)
            }
        }
    }
    
    func listCurrentTemperatureNextCities(sucess:@escaping(_ listWeaterInfo:Array<WeaterInfo>) -> Void){
        var mockListWeaterApi: Array<WeaterInfo> = []
        let CNT = 21
        let QUERYPARAMS = "find?lat=\(lat)&lon=\(lng)&appid=\(APIKEY)&cnt=\(CNT)&units=metric"
        AF.request(BASE_LIST + QUERYPARAMS, method: .get).responseJSON { response in
            switch response.result {
            case .success:
            do{
              guard let dictResponse = try response.result.get() as? Dictionary<String, Any>,
                    let listCities = dictResponse["list"] as? Array<Dictionary<String, Any>> else{
                    print("Erro ao desserializar response")
                    return
                }
                for city in listCities {
                    if let name = city["name"] as? String, let coord = city["coord"] as? Dictionary<String, Any>,
                       let lat = coord["lat"] as? Double, let lng = coord["lon"] as? Double,
                       let main = city["main"] as? Dictionary<String, Any>, let temp = main["temp"] as? Double {
                        mockListWeaterApi.append(WeaterInfo(lat: String(lat), lng: String(lng), temperature: String(temp),
                                                 city: name))
                    }
                }
                sucess(mockListWeaterApi)
            }catch{
                print("Erro ao desserializar info")
            }
            case .failure:
                print(response.error!)
            }
        }
        return sucess(mockListWeaterApi)
    }
    
}
