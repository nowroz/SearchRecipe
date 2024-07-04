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
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    let recipeClient: RecipeClient = RecipeClient()
    
    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    ContentUnavailableView {
                        Label("No Recipes Found", systemImage: "magnifyingglass")
                    } description: {
                        Text("Search recipes to view them.")
                    }
                } else {
                    RecipeListView(recipes: recipes)
                }
            }
            .navigationTitle("SearchRecipe")
        }
        .searchable(text: $searchString, prompt: "Search Recipes")
        .onSubmit(of: .search) {
            Task {
                print("new task")
                await loadRecipes()
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            
        } message: {
            Text(alertMessage)
        }
    }
    
    @MainActor func loadRecipes() async {
        do {
            let trimmedSearchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
            recipes = try await recipeClient.searchRecipe(trimmedSearchString)
        } catch URLError.notConnectedToInternet {
            displayAlert(title: "No Internet", message: "It appears you are offline. Please check your connection and try again.")
        } catch URLError.badServerResponse {
            displayAlert(title: "Oops!", message: "There was an error loading your recipes. Please try again.")
        } catch {
            fatalError("Failed to load recipes - \(error.localizedDescription)")
        }
    }
    
    func displayAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}
#Preview {
    ContentView()
}
