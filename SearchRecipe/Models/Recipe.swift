//
//  Recipe.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 4/7/24.
//

import Foundation

struct RecipeResponse: Decodable {
    let results: [Recipe]
}

struct Recipe: Identifiable, Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "pk"
        case title
        case featuredImage = "featured_image"
    }
    
    let id: Int
    let title: String
    let featuredImage: URL
}
