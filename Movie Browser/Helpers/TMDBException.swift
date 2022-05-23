//
//  TMDBException.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

struct TMDBException: Error {
    let code: Int
    let localizedDescription: String
}
