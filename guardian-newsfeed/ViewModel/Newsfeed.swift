//
//  Newsfeed.swift
//  guardian-newsfeed
//
//  Created by Nouman on 04/05/2021.
//

import Foundation

class Newsfeed: ObservableObject {
    @Published var data = [Result]()

    init(){
        let url = "https://content.guardianapis.com/search?show-fields=headline%2Cthumbnail%2CtrailText%2CbodyText&q=coronavirus&api-key=7c566cc2-9cc5-4a08-942d-c4106344049c"
        guard let api = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: api) { (data, resp, err) in
            let result = try! JSONDecoder().decode(NewsfeedResponse.self, from: data!)
            DispatchQueue.main.async {
                self.data = result.response.results
            }
        }.resume()
    }
    
}


