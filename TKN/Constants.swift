//
//  Constants.swift
//  TKN
//
//  Created by Oak on 4/21/23.
//  Copyright © 2023 Superadditive. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let hostUrl: String = "https://tkn.xyz"
    static let tab0: String = Constants.hostUrl + "?frame=ios"
    static let tab1: String = Constants.hostUrl + "/edit?frame=ios"
    static let tab2: String = Constants.hostUrl + "/search?frame=ios"
    static let tab3: String = Constants.hostUrl + "/portfolio?frame=ios"
    
    static let backgroundColor: UIColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.00)
 }

// MARK: - Helpers

func makeSearchUrl(query: String) -> String {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    return "\(Constants.hostUrl)/search/\(encodedQuery)?ios=true"
}
