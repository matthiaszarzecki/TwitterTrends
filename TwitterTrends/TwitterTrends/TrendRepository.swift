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
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    func getTrends(completion: @escaping ([Trend]) -> Void) {
        restClient.getRequest(withURL: "urlString") { [weak self] data in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let results = try JSON(data: data).arrayValue
                    let trendData = results[0]["trends"].arrayValue
                    for trend in trendData {
                        let newTrend = Trend(name: trend["name"].stringValue,
                                             query: trend["query"].stringValue,
                                             tweetVolume: trend["tweet_volume"].intValue,
                                             promotedContent: trend["promoted_content"].boolValue,
                                             url: trend["url"].stringValue)
                        
                        self?.trends.append(newTrend)
                    }
                } catch{}
            }
            
            DispatchQueue.main.async {
                completion((self?.trends)!)
            }
        }
    }
    
    /*func getWildCards(completion: @escaping ([Person]) -> Void) {
        restClient.getRequest(url: urlString) { [weak self] data in
            DispatchQueue.global(qos: .userInitiated).async {
                let results = JSON(data: data).arrayValue
                for person in results {
                    let person = Person(age: person["age"].uIntValue,
                                        city: person["city"].stringValue,
                                        firstName: person["firstname"].stringValue,
                                        id: person["id"].stringValue,
                                        job: person["job"].stringValue,
                                        name: person["name"].stringValue,
                                        wantChildren: person["wish_for_children"].boolValue,
                                        isSmoker: person["smoker"].boolValue,
                                        postCode: person["postcode"].intValue,
                                        images: person["images"].arrayObject as! [String])
                    
                    self?.people.append(person)
                }
                
                DispatchQueue.main.async {
                    completion((self?.people)!)
                }
            }
        }
    }*/
}
