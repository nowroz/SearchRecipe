//
//  Response.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 29/9/24.
//

import Foundation

struct Response: Decodable {
    let results: [Recipe]
}
