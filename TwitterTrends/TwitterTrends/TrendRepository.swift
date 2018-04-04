//
//  TrendRepository.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 09.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

class TrendRepository {
    let restClient: RESTClient
    var trends = [Trend]()
    let baseURL = "https://api.twitter.com/"
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    public func getTrends(bearerToken: String, completion: @escaping ([Trend]) -> Void) {
        restClient.getRequest(withRequest: getTrendsRequest(bearerToken: bearerToken)) { (data) in
            self.trends = self.getTrendsFromData(data: data)
            completion(self.trends)
        }
    }
    
    private func getTrendsFromData(data: Data) -> [Trend] {
        var newTrends = [Trend]()
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dataArray = json as? [Any] {
            if let dataDictionary = dataArray[0] as? [String : Any] {
                if let trends = dataDictionary["trends"] as? [Any] {
                    for trend in trends {
                        if let currentTrend = trend as? [String : Any] {
                            let newTrend = Trend(name: currentTrend["name"] as? String ?? "",
                                                 query: currentTrend["query"] as? String ?? "",
                                                 tweetVolume: currentTrend["tweet_volume"] as? Int ?? 0,
                                                 promotedContent: currentTrend["promoted_content"] as? Bool ?? false,
                                                 url: currentTrend["url"] as? String ?? "")
                            newTrends.append(newTrend)
                        }
                    }
                }
            }
        }
        return newTrends
    }
    
    private func getTrendsRequest(bearerToken: String) -> URLRequest {
        let path = "1.1/trends/place.json"
        let params = "id=638242"
        let url = getURL(path: path, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getURL(path: String, params: String) -> URL {
        let urlString = "\(baseURL)\(path)?\(params)"
        return URL(string: urlString)!
    }
}
