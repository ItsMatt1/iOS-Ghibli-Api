//
//  Film.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

// Modelo de dados do filme da API Studio Ghibli
struct Film: Codable, Identifiable {
    let id: String
    let title: String
    let originalTitle: String
    let originalTitleRomanised: String
    let description: String
    let director: String
    let producer: String
    let releaseDate: String
    let runningTime: String
    let rtScore: String
    let image: String? // URL da imagem thumbnail
    let movieBanner: String? // URL do banner do filme
    
    // Mapeamento de snake_case (API) para camelCase (Swift)
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case originalTitleRomanised = "original_title_romanised"
        case description
        case director
        case producer
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case rtScore = "rt_score"
        case image
        case movieBanner = "movie_banner"
    }
}
