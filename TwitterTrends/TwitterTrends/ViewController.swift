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
    
    var objects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTokenAndAddDataToView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Internal Functions
    
    func loadTokenAndAddDataToView() {
        //create login-hash
        let loginString = String(format: "%@:%@", twitterConsumerKey, twitterSecretKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        //create request
        let url = URL(string: "https://api.twitter.com/oauth2/token?grant_type=client_credentials")!
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
    
    func loadTrends() {
        //load trends with authentication included
        let url = URL(string: "https://api.twitter.com/1.1/trends/place.json?id=638242")!
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
    
    func addTrendsToTableView(data: JSON) {
        let trends = data[0]["trends"]
        print("Trends: \(trends)")
        for currentItem in data[0]["trends"].arrayValue {
            self.objects.append(currentItem["name"].stringValue)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table View Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row]
        return cell
    }
}
