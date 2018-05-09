//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 27.02.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit
import Bond
import SafariServices
import Foundation

class TrendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModelTrends = ViewProvider.viewModelTrends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getTrends()
    }
    
    // MARK: - Internal Functions
    
    private func getTrends() {
        viewModelTrends.getTrends() { () in
            self.viewModelTrends.trends.bind(to: self.tableView, animated: true, createCell: { (trends, indexPath, tableView) -> UITableViewCell in
                return self.prepareCell(trends: ViewProvider.viewModelTrends.trends, tableView: tableView, indexPath: indexPath)
            })
        }
    }
    
    private func getTweetVolumeDisplayString(forVolume volume: Int?) -> String {
        if volume != nil && volume != 0, let volumeInt = volume {
            return "\(volumeInt) Tweets"
        }
        return ""
    }
    
    private func prepareCell(trends: MutableObservableArray<Trend>, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = self.viewModelTrends.trends[indexPath.row].name
        cell.detailTextLabel?.text = self.getTweetVolumeDisplayString(forVolume: self.viewModelTrends.trends[indexPath.row].tweetVolume)
        return cell
    }
    
    // MARK: - Table View Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Berlin Trending" : "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelTrends.trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return prepareCell(trends: viewModelTrends.trends, tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: viewModelTrends.trends[indexPath.row].url!) else {
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
