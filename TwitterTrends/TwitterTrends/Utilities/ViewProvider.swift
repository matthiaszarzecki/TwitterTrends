//
//  ViewProvider.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 20.04.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import Foundation

struct ViewProvider {
    static public let viewModelTrends = ViewModelTrends(repository: AppProvider.trendRepository)
}
