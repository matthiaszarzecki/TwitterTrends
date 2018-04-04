//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 27.02.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {

    let twitterConsumerKey = "IcGVWgJhPZxDhchayq9TtT7kh"
    let twitterSecretKey = "kQdHgDg6DowQRgt0Q3ocfZCBuSYT0gIkLq46fTFkomW9dNJBr7"
    var bearerToken: String = ""
    var trends = [Trend]()
    
    private let restClient = RESTClient(urlSession: URLSession.shared)
    private var repository = TrendRepository(restClient: RESTClient(urlSession: URLSession.shared))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTokenAndAddDataToView()
    }
    
    // MARK: Internal Functions
    
    private func loadTokenAndAddDataToView() {
        restClient.getRequest(withRequest: getAuthenticationRequest()) { (data) in
            self.bearerToken = self.getTokenFromData(data: data)
            if self.bearerToken != "" {
                self.loadTrends()
            }
        }
    }
    private func getTokenFromData(data: Data) -> String {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let jsonDict = json as? [String : Any] {
            return jsonDict["access_token"] as? String ?? ""
        }
        return ""
    }
    
    private func loadTrends() {
        self.repository.getTrends(bearerToken: self.bearerToken, completion: { (data) in
            self.trends = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
    
    // MARK: Table View Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Berlin Trends" : "Section \(section)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = trends[indexPath.row].name
        return cell
    }
}
