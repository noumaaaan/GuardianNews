//
//  DataModel.swift
//  guardian-newsfeed
//
//  Created by Nouman on 04/05/2021.
//

import Foundation

struct NewsfeedResponse: Codable {
    let response: Response
}
struct Response: Codable {
    let status : String
    let total, startIndex, pageSize, currentPage, pages: Int
    let results: [Result]
}
struct Result: Codable, Identifiable {
    let id, sectionName: String
    let fields: Fields
}
struct Fields: Codable {
    let trailText, bodyText, headline, thumbnail: String
}

