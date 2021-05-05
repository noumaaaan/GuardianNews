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
    
    func loadData(pageParam: Int) {
        
        if (totalPages != nil) {
            if (pageParam > totalPages!) {
                return
            }
        }
        let url = "https://content.guardianapis.com/search?order-by=newest&show-fields=bodyText%2Cheadline%2CtrailText%2Cthumbnail&page=\(pageParam)&q=coronavirus&api-key=7c566cc2-9cc5-4a08-942d-c4106344049c"
        guard let api = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: api) { (data, resp, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(NewsfeedResponse.self, from: data)
                    self.totalPages = result.response.pages
                    DispatchQueue.main.async {
                        self.pageSize += result.response.pageSize
                        self.data.append(contentsOf: result.response.results)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}


