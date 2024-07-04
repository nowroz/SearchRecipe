//
//  RecipeClient.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 4/7/24.
//

import Foundation

struct RecipeClient {
    func searchRecipe(_ searchString: String) async throws -> [Recipe] {
        do {
            let endpoint = "https://food2fork.ca/api/recipe/search/?page=2&query=\(searchString)"
            guard let url = URL(string: endpoint) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.setValue("Token 9c8b06d329136da358c2d00e76946b0111ce2c48", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLRespone = response as? HTTPURLResponse, (200...299).contains(httpURLRespone.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return recipeResponse.results
        } catch URLError.badURL {
            fatalError("Invalid URL")
        } catch URLError.badServerResponse {
            throw URLError(.badServerResponse)
        } catch DecodingError.valueNotFound(_, let context) {
            fatalError("Decoding Error. Found nil - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Decoding Error. Invalid JSON file - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Decoding Error. Type mismatch - \(context.debugDescription)")
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Decoding Error. Missing key named '\(key.stringValue)' - \(context.debugDescription)")
        } catch URLError.notConnectedToInternet {
            throw URLError(.notConnectedToInternet)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
