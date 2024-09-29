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
            HStack(spacing: 15) {
                AsyncImage(url: recipe.featuredImage) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(.rect(cornerRadius: 10))
                    case .failure(_):
                        Image(systemName: "exclamationmark.triangle.fill")
                    @unknown default:
                        fatalError("Failed to load image")
                    }
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.headline.weight(.semibold))
                    
                    Text(recipe.publisher)
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var response: Response = .init(results: [])
    
    NavigationStack {
        RecipeListView(recipes: response.results)
            .navigationTitle("SearchRecipe")
            .task {
                response = try! await DataLoader().loadData(from: "https://food2fork.ca/api/recipe/search/?query=burger")
            }
    }
}
