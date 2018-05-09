//
//  ViewModelTrends.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 20.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit
import Foundation
import Bond

class ViewModelTrends {
    private let repository: TrendRepository
    public var trends = MutableObservableArray<Trend>()
    
    init(repository: TrendRepository) {
        self.repository = repository
    }
    
    public func getTrends(completion: @escaping () -> Void) {
        Authentication.getBearerToken() { (data) in
            if let token = data {
                self.repository.getTrends(bearerToken: token) { (data) in
                    for item in data {
                        self.trends.append(item)
                    }

                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
}
