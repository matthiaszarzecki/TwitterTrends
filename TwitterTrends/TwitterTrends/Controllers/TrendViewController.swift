//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 27.02.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit
import Bond
import Foundation

class TrendViewController: UIViewController {
    
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
    
    internal func prepareCell(trends: MutableObservableArray<Trend>, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = self.viewModelTrends.trends[indexPath.row].name
        cell.detailTextLabel?.text = self.getTweetVolumeDisplayString(forVolume: self.viewModelTrends.trends[indexPath.row].tweetVolume)
        let promoted = self.viewModelTrends.trends[indexPath.row].promotedContent ?? false
        if promoted {
            cell.backgroundColor = UIColor.colorFromHexString(Constants.colorHexPromotedContentCell)
        }
        return cell
    }
}
