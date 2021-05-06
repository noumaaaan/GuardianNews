//
//  Newsfeed.swift
//  guardian-newsfeed
//
//  Created by Nouman on 04/05/2021.
//

import Foundation

class Newsfeed: ObservableObject {
    
    @Published var data = [Result]()
    
    var totalPages: Int?
    var pageSize: Int = 0
    
    init() {
        loadData(pageParam: 1, search: nil, key: nil) { result, size in
            if (result != nil) { self.data.append(contentsOf: result!) }
            if (size != nil) { self.pageSize += size! }
        }
    }
    
    func loadData(pageParam: Int, search: String?, key: String?, completion: @escaping ([Result]?, Int?) -> Void) {

        let searchTerm, apiKey: String
        if (search != nil) { searchTerm = search! } else { searchTerm = "coronavirus" }
        if (key != nil) { apiKey = key! } else { apiKey = "7c566cc2-9cc5-4a08-942d-c4106344049c" }
        
        
        let apiUrl = "https://content.guardianapis.com/search?order-by=newest&show-fields=bodyText%2Cheadline%2CtrailText%2Cthumbnail&page=\(pageParam)&q=\(searchTerm)&api-key=\(apiKey)"
        
        if (totalPages != nil) {
            if (pageParam > totalPages!) {
                return
            }
        }
        
        guard let api = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: api) { (data, resp, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(NewsfeedResponse.self, from: data)
                    
                    self.totalPages = result.response?.pages
                    DispatchQueue.main.async {
                        let final = result.response?.results
                        completion(final, result.response!.pageSize)
                    }

                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


