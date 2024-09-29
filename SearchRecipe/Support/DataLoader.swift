//
//  DataLoader.swift
//  SearchRecipe
//
//  Created by Nowroz Islam on 29/9/24.
//

import Foundation

enum DataLoadingError: Error {
    case invalidURL
    case badResponse
}

struct DataLoader<T: Decodable> {
    func loadData(from endpoint: String) async throws -> T {
        let data = try await fetchSerializedData(from: endpoint)
        let content = decode(data)
        
        return content
    }
    
    private func decode(_ data: Data) -> T {
        do {
            let content = try JSONDecoder().decode(T.self, from: data)
            
            return content
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Decoding Error. Found nil value for \(type) - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Decoding Error - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Decoding Error. Type mismatch - \(context.debugDescription)")
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Decoding Error. Missing key, \(key.stringValue) - \(context.debugDescription)")
        } catch {
            fatalError("Decoding Error - \(error.localizedDescription)")
        }
    }
    
    private func fetchSerializedData(from endpoint: String) async throws -> Data {
        do {
            guard let url = URL(string: endpoint) else { throw DataLoadingError.invalidURL }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Token 9c8b06d329136da358c2d00e76946b0111ce2c48", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                throw DataLoadingError.badResponse
            }
            
            return data
        } catch DataLoadingError.invalidURL {
            fatalError("Invalid URL")
        } catch DataLoadingError.badResponse {
            fatalError("Bad response")
        } catch URLError.notConnectedToInternet {
            throw URLError(.notConnectedToInternet)
        } catch {
            fatalError("Failed to fetch data from the internet - \(error.localizedDescription)")
        }
    }
}
