//
//  TrendRepository.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 09.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrendRepository {
    let restClient: RESTClient
    var trends = [Trend]()
    let baseURL = "https://api.twitter.com/"
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    public func getTrends(bearerToken: String, completion: @escaping ([Trend]) -> Void) {
        restClient.getRequest(withRequest: getTrendsRequest(bearerToken: bearerToken)) { (data) in
            do {
                let results = try JSON(data: data)
                self.trends = self.getTrendsFromJSON(data: results)
                completion(self.trends)
            } catch {}
        }
    }
    
    private func getTrendsFromJSON(data: JSON) -> [Trend] {
        let trendData = data[0]["trends"].arrayValue
        var newTrends = [Trend]()
        for trend in trendData {
            let newTrend = Trend(name: trend["name"].stringValue,
                                 query: trend["query"].stringValue,
                                 tweetVolume: trend["tweet_volume"].intValue,
                                 promotedContent: trend["promoted_content"].boolValue,
                                 url: trend["url"].stringValue)
            
            newTrends.append(newTrend)
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
