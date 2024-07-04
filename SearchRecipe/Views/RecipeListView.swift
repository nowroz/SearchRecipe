//
//  RecipeListView.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 4/7/24.
//

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    
    var body: some View {
        List(recipes) { recipe in
            HStack {
                AsyncImage(url: recipe.featuredImage) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                
                Text(recipe.title)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeListView(recipes: [])
    }
}
