//
//  ContentView.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 4/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchString: String = ""
    @State private var recipes: [Recipe] = []
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    ContentUnavailableView("No Recipes Found", systemImage: "magnifyingglass", description: Text("Search recipes to view them."))
                } else {
                    RecipeListView(recipes: recipes)
                }
            }
            .navigationTitle("SearchRecipe")
            .searchable(text: $searchString, prompt: "Search Recipes")
            .onChange(of: searchString) {
                Task {
                    await loadRecipes()
                }
            }
            .alert("No Internet", isPresented: $showingAlert) {
                
            } message: {
                Text("It seems you are not connected to the internet. Please check your connection and try again.")
            }
        }
    }
    
    func loadRecipes() async {
        do {
            let trimmedSearchString = searchString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard trimmedSearchString.isEmpty == false else { return }
            
            let response: Response = try await DataLoader().loadData(from: "https://food2fork.ca/api/recipe/search/?query=\(trimmedSearchString)")
            
            recipes = response.results
        } catch URLError.notConnectedToInternet {
            showingAlert = true
        } catch {
            fatalError("Failed to load recipes - \(error.localizedDescription)")
        }
    }
}
#Preview {
    ContentView()
}
