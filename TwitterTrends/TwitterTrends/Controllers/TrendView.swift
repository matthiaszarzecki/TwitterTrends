//
//  TrendView.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 03.05.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation
import UIKit
import Bond
import SafariServices

class TrendView: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
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
        cell.detailTextLabel?.text = getTweetVolumeDisplayString(forVolume: ViewProvider.viewModelTrends.trends[indexPath.row].tweetVolume)
        return cell
    }
    
    private func getTweetVolumeDisplayString(forVolume volume: Int?) -> String {
        if volume != nil && volume != 0, let volumeInt = volume {
            return "\(volumeInt) Tweets"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: ViewProvider.viewModelTrends.trends[indexPath.row].url!) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        self.tableView.deselectRow(at: indexPath, animated: true)
        present(safariVC, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
