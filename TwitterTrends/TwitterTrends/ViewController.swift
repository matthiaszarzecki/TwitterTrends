//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 27.02.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private var bearerToken: String?
    var trends = [Trend]()
    
    private let restClient = RESTClient(urlSession: URLSession.shared)
    private var repository = TrendRepository(restClient: RESTClient(urlSession: URLSession.shared))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrendsAndAddDataToView()
    }
    
    // MARK: Internal Functions
    
    private func loadTrendsAndAddDataToView() {
        Authentication.getBearerToken() { (data) in
            self.bearerToken = data
            
            if let token = self.bearerToken {
                self.loadTrends(token: token)
            }
        }
    }
    
    private func loadTrends(token: String) {
        self.repository.getTrends(bearerToken: token) { (data) in
            self.trends = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
