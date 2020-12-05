//
//  WeatherManager.swift
//  Clima
//
//  Created by Emmanuel Cuevas on 03/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=76bd0ad1de73a7bd30b53266f7b49d6b&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //        1.Create the URL
        if let url = URL(string: urlString){
            //        2. Create the URL session
            let session = URLSession(configuration: .default)
            //        3. Give the session a task
            //            let task = session.dataTask(with: url, completionHandler: handler(data:urlResponse:error:))
            //            Closure version of step 3
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    //                    This next lines define the dataString to a safe String
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString)
                    self.parseJSON(weatherData: safeData)
                    
                    
                }
            }
            
            //        4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder ()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.id)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch{
            print(error)
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
