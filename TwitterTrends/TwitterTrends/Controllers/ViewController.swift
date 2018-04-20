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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getTrends()
    }
    
    // MARK: Internal Functions
    
    private func getTrends() {
        ViewProvider.viewModelTrends.getTrends() { () in
            self.tableView.reloadData()
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
        return ViewProvider.viewModelTrends.trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = ViewProvider.viewModelTrends.trends[indexPath.row].name
        return cell
    }
}
