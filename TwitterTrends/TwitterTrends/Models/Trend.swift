//
//  TrendModel.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 09.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

typealias TrendResponse = [TrendArray]

struct TrendArray: Codable {
    let trends: [Trend]?
    let asOf: String?
    let createdAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case trends
        case asOf = "as_of"
        case createdAt = "created_at"
    }
}

struct Trend: Codable {
    let name: String?
    let query: String?
    let tweetVolume: Int?
    let promotedContent: Bool?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case query
        case tweetVolume = "tweet_volume"
        case promotedContent = "promoted_content"
        case url
    }
}
