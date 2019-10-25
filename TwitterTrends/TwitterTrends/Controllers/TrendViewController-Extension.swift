//
//  TrendViewController+Extension.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 28.05.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit
import SafariServices

extension TrendViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.colorFromHexString(Constants.colorHexTwitterTrendsLightBlue)
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
}

extension TrendViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
