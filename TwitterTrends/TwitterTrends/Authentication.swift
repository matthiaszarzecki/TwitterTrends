//
//  Authentication.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 18.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

class Authentication {
    
    private let twitterConsumerKey = "IcGVWgJhPZxDhchayq9TtT7kh"
    private let twitterSecretKey = "kQdHgDg6DowQRgt0Q3ocfZCBuSYT0gIkLq46fTFkomW9dNJBr7"
    private var bearerToken: String?
    
    private let restClient = RESTClient(urlSession: URLSession.shared)
    
    init() {
        loadToken()
    }
    
    public func getBearerToken(completion: @escaping (_ token: String?) -> Void) {
        if bearerToken != nil {
            completion(bearerToken)
            return
        }
        
        restClient.getRequest(withRequest: getAuthenticationRequest()) { (data) in
            self.bearerToken = self.getTokenFromData(data: data)
            if self.bearerToken != "" {
                completion(self.bearerToken)
            }
        }
    }
    
    private func loadToken() {
        restClient.getRequest(withRequest: getAuthenticationRequest()) { (data) in
            self.bearerToken = self.getTokenFromData(data: data)
        }
    }
    
    private func getTokenFromData(data: Data) -> String {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let jsonDict = json as? [String : Any] {
            return jsonDict["access_token"] as? String ?? ""
        }
        return ""
    }
    
    private func getAuthenticationRequest() -> URLRequest {
        let loginString = String(format: "%@:%@", twitterConsumerKey, twitterSecretKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let path = "oauth2/token"
        let params = "grant_type=client_credentials"
        let url = Utilities.getURL(path: path, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("29", forHTTPHeaderField: "Content-Length")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        return request
    }
}
