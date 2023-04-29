//
//  Constants.swift
//  TKN
//
//  Created by Oak on 4/21/23.
//  Copyright © 2023 Superadditive. All rights reserved.
//

import Foundation

struct Constants {
    static let hostUrl: String = "https://tkn.xyz"
    static let tab0: String = Constants.hostUrl + "?frame=ios"
    static let tab1: String = Constants.hostUrl + "/edit?frame=ios"
    static let tab2: String = Constants.hostUrl + "/search?frame=ios"
    static let tab3: String = Constants.hostUrl + "/portfolio?frame=ios"
 }

func makeSearchUrl(query: String) -> String {
    return "\(Constants.hostUrl)/search/\(query)?ios=true"
}
