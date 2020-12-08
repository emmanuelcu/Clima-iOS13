//
//  WeatherManager.swift
//  Clima
//
//  Created by Emmanuel Cuevas on 03/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//Protocol that certifies that the VC that makes the calls uses the didUpdateWeather function.

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=76bd0ad1de73a7bd30b53266f7b49d6b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(/*urlString*/with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(/* previous code::: urlString: String*/ with urlString: String) {
        //        1.Create the URL
        if let url = URL(string: urlString){
            //        2. Create the URL session
            let session = URLSession(configuration: .default)
            //        3. Give the session a task
            //            let task = session.dataTask(with: url, completionHandler: handler(data:urlResponse:error:))
            //            Closure version of step 3
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //                    This next lines define the dataString to a safe String
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString)
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //        4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder ()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //            print(weather.conditionName)
            //            print(weather.temperatureString)
            //            print(decodedData.name)
            //            print(decodedData.id)
            //            print(decodedData.main.temp)
            //            print(decodedData.weather[0].description)
            //            print(decodedData.weather[0].id)
            
            return weather
            
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    //    This function is commented because it is performed in the closure above created
    //    func handler(data: Data?, urlResponse: URLResponse?, error: Error?){
    //        if error != nil{
    //            print(error!)
    //            return
    //        }
    //
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }
}
