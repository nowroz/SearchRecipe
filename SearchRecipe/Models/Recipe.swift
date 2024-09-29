//
//  Recipe.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 4/7/24.
//

import Foundation

struct Recipe {
    let id: Int
    let title: String
    let publisher: String
    let featuredImage: URL
}

extension Recipe: Identifiable {
    
}

extension Recipe: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "pk"
        case title
        case publisher
        case featuredImage = "featured_image"
    }
}
