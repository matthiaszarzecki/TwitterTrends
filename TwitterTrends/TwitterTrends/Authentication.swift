//
//  Authentication.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 18.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

class Authentication {
    static private var bearerToken: String?
    static private let restClient = RESTClient(urlSession: URLSession.shared)
    
    init() {
        Authentication.loadToken() { (data) in
        }
        
        //init restclient via dependency injection
    }
    
    static public func getBearerToken(completion: @escaping (_ token: String?) -> Void) {
        if bearerToken != nil {
            completion(bearerToken)
        } else {
            loadToken() { (data) in
                completion(bearerToken)
            }
        }
    }
    
    static private func loadToken(completion: @escaping (_ token: String?) -> Void) {
        restClient.getRequest(withRequest: getAuthenticationRequest()) { (data) in
            bearerToken = getTokenFromData(data: data)
            if bearerToken != nil {
                completion(bearerToken)
            }
        }
    }
    
    static private func getTokenFromData(data: Data) -> String? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let jsonDict = json as? [String : Any] {
            return jsonDict["access_token"] as? String ?? nil
        }
        return nil
    }
    
    static private func getAuthenticationRequest() -> URLRequest {
        let encodedLoginString = getEncodedLoginString(consumerKey: Constants.twitterConsumerKey, secretKey: Constants.twitterSecretKey)
        let path = "oauth2/token"
        let params = "grant_type=client_credentials"
        let url = Utilities.getURL(path: path, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(encodedLoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("29", forHTTPHeaderField: "Content-Length")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        return request
    }
    
    static private func getEncodedLoginString(consumerKey: String, secretKey: String) -> String {
        let loginString = String(format: "%@:%@", consumerKey, secretKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
}
