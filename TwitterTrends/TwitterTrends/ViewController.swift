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
    let baseURL = "https://api.twitter.com/"
    
    var bearerToken: String = ""
    
    var trends = [Trend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTokenAndAddDataToView()
        
        //Load token
        //Get Trends
        //Add trends to view
    }
    
    // MARK: Internal Functions
    
    private func loadTokenAndAddDataToView() {
        //create login-hash
        let loginString = String(format: "%@:%@", twitterConsumerKey, twitterSecretKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        //create request
        let path = "oauth2/token"
        let params = "grant_type=client_credentials"
        let url = getURL(path: path, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("29", forHTTPHeaderField: "Content-Length")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        //send off request for bearerToken
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let results = try JSON(data: data)
                    self.bearerToken = results["access_token"].stringValue;
                    print("Results: \(results)")
                    self.loadTrends()
                } catch {}
            }
        }).resume()
    }
    
    private func loadTrends() {
        //load trends with authentication included
        let path = "1.1/trends/place.json"
        let params = "id=638242"
        let url = getURL(path: path, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let results = try JSON(data: data)
                    self.addTrendsToTableView(data: results)
                } catch {}
            }
        }).resume()
    }
    
    private func addTrendsToTableView(data: JSON) {
        let trendData = data[0]["trends"].arrayValue
        print("Trends: \(trends)")
        for trend in trendData {
            let newTrend = Trend(name: trend["name"].stringValue,
                                 query: trend["query"].stringValue,
                                 tweetVolume: trend["tweet_volume"].intValue,
                                 promotedContent: trend["promoted_content"].boolValue,
                                 url: trend["url"].stringValue)
            
            self.trends.append(newTrend)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getURL(path: String, params: String) -> URL {
        let urlString = "\(baseURL)\(path)?\(params)"
        return URL(string: urlString)!
    }
    
    // MARK: Table View Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Berlin Trends"
        } else {
            return "Section \(section)"
        }
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
