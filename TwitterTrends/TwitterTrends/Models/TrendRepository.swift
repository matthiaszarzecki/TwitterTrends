//
//  TrendRepository.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 09.03.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

final class TrendRepository {
  private let restClient: RESTClient
  private var trends = [Trend]()
  
  init(restClient: RESTClient) {
    self.restClient = restClient
  }
  
  public func getTrends(
    bearerToken: String,
    sorted: Bool = true,
    completion: @escaping ([Trend]) -> Void
  ) {
    restClient.getRequest(withRequest: getTrendsRequest(bearerToken: bearerToken)) { (data) in
      if let newTrends = self.getTrendsFromData(data: data) {
        self.trends = newTrends
      }
      
      if sorted {
        self.trends = self.sortTrendsByVolume(trends: self.trends)
      }
      
      completion(self.trends)
    }
  }
  
  private func sortTrendsByVolume(
    trends: [Trend]
  ) -> [Trend] {
    return trends.sorted(by: { $0.tweetVolume ?? 0 > $1.tweetVolume ?? 0 })
  }
  
  private func getTrendsFromData(data: Data) -> [Trend]? {
    let response = self.getTrendArrayFromData(data: data)
    return response?.trends
  }
  
  private func getTrendArrayFromData(data: Data) -> TrendArray? {
    var response: [TrendArray]? = nil
    do {
      response = try JSONDecoder().decode(TrendResponse.self, from: data)
    } catch {
      print(error)
    }
    return response?.first
  }
  
  private func getTrendsRequest(bearerToken: String) -> URLRequest {
    let path = "1.1/trends/place.json"
    let params = "id=\(Constants.woeIDBerlin)"
    let url = Utilities.getURL(path: path, params: params)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
    return request
  }
}
