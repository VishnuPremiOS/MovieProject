//
//  ApiManager.swift
//  BuyMeCoffePjt
//
//  Created by NigilKowsi on 29/03/24.
//

import Foundation
import UIKit

// Network Manager
class ApiManager {
    static let shared = ApiManager()
    private init() {}

    func fetchMovies(completion: @escaping ([Results]?) -> Void) {
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=jack+johnson&limit=25") else {
                completion(nil)
                return
            }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(Movies_Base.self, from: data)
                let movies = result.results
                completion(movies)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
