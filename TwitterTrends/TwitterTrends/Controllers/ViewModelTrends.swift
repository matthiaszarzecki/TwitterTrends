//
//  ViewModelTrends.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 20.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit

class ViewModelTrends {
    private let repository: TrendRepository
    public var trends = [Trend]()
    
    init(repository: TrendRepository) {
        self.repository = repository
    }
    
    public func getTrends(completion: @escaping ([Trend]) -> Void) {
        Authentication.getBearerToken() { (data) in
            if let token = data {
                self.repository.getTrends(bearerToken: token) { (data) in
                    self.trends = data
                    DispatchQueue.main.async {
                        completion(self.trends)
                    }
                }
            }
        }
    }
}
