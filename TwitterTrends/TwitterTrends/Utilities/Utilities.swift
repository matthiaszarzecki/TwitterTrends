//
//  Utilities.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 04.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

struct Utilities {
  static func getURL(path: String, params: String) -> URL {
    let urlString = "\(Constants.baseURL)\(path)?\(params)"
    return URL(string: urlString)!
  }
}
