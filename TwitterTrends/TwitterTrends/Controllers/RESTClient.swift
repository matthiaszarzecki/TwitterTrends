//
//  RESTClient.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 02.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit

struct RESTClient {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getRequest(withURL url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else {
            return print("not a valid url string")
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data)
            }
        }.resume()
    }
    
    func getRequest(withRequest request: URLRequest, completion: @escaping (Data) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data)
            }
        }.resume()
    }
}
