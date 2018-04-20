//
//  AppProvider.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 19.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

struct AppProvider {
    static let restClient = RESTClient(urlSession: AppProvider.urlSession)
    static let trendRepository = TrendRepository(restClient: AppProvider.restClient)
    private static let urlSession = URLSession.shared
}
