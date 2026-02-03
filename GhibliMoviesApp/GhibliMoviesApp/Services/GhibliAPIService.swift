//
//  GhibliAPIService.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .httpError(let statusCode):
            return "Erro HTTP: \(statusCode)"
        case .decodingError:
            return "Erro ao decodificar os dados"
        case .networkError:
            return "Erro de conexão. Verifique sua internet."
        }
    }
}

// Actor para operações de networking - isolamento de concorrência seguro
actor GhibliAPIService {
    private let baseURL = "https://ghibliapi.vercel.app"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchFilms() async throws -> [Film] {
        guard let url = URL(string: "\(baseURL)/films") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let films = try JSONDecoder().decode([Film].self, from: data)
                return films
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchFilm(id: String) async throws -> Film {
        guard let url = URL(string: "\(baseURL)/films/\(id)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return film
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
