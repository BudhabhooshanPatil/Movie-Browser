//
//  Parser.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    struct Result: Codable {
        let voteCount: Int?
        let id: Int?
        let video: Bool?
        let voteAverage: Double?
        let title: String?
        let popularity: Double?
        let posterPath: String?
        let originalLanguage: String?
        let originalTitle: String?
        let genreids: [Int]?
        let backdropPath: String?
        let adult: Bool?
        let overview: String?
        let releaseDate: String?
        let genres: [Genre]?

        enum CodingKeys: String, CodingKey {
            case voteCount = "vote_count"
            case id = "id"
            case video = "video"
            case voteAverage = "vote_average"
            case title = "title"
            case popularity = "popularity"
            case posterPath = "poster_path"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreids = "genre_ids"
            case backdropPath = "backdrop_path"
            case adult = "adult"
            case overview = "overview"
            case releaseDate = "release_date"
            case genres = "genres"

        }
    }
    struct Genre: Codable {
        let id: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
        }
    }
}

struct TMDBError: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

