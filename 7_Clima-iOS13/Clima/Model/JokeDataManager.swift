//
//  JokeDataManager.swift
//  Clima
//
//  Created by Uki on 2024/11/22.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol JokeManagerDelegate {
    func updateJoke(jokeModel: JokeModel)
    func failedWithError(error: Error)
}

struct JokeDataManager {
    let apiUrl = "https://icanhazdadjoke.com/"
    var delegate: JokeManagerDelegate?
    
    func fetchJoke() {
        performRequest(url: apiUrl)
    }
    
    func performRequest(url: String){
        // 1. Create URL
        if let url = URL(string: url){
            //2. Create Request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            // 3. Create URL Session
            let session = URLSession(configuration: .default)
            
            // 4. Give the session with task
            let task = session.dataTask(with: request) { (data, response, error) in
                // if error exists
                if error != nil{
                    self.delegate?.failedWithError(error: error!)
                    return
                }

                // Decode JSON
                if let safeData = data{
                    // "self" is necessery in closure
                    if let joke = self.parseJSON(jokeData: safeData) {
                        self.delegate?.updateJoke(jokeModel: joke)
                    }
                }
            }
            // 5. Start the task
            task.resume()
        }
    }   // [END] of performRequest()

    // decode JSON
    func parseJSON(jokeData: Data) -> JokeModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(JokeData.self, from: jokeData)
            print("decoded: \(decodedData)")
            return JokeModel(joke: decodedData.joke)
            
        }catch {
            return nil
        }
    }
}
