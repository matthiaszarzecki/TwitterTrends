//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 27.02.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    private var bearerToken: String?
    var trends = [Trend]()
    
    private let restClient = RESTClient(urlSession: URLSession.shared)
    private var repository = TrendRepository(restClient: RESTClient(urlSession: URLSession.shared))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Berlin Trending" : "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = trends[indexPath.row].name
        return cell
    }
}
