//
//  GhibliAPIService.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

// Enum de erros customizados para operações de API
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    
    // Mensagens de erro localizadas em português
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
    
    // Busca todos os filmes da API
    func fetchFilms() async throws -> [Film] {
        guard let url = URL(string: "\(baseURL)/films") else {
            throw APIError.invalidURL
        }
        
        do {
            // Faz requisição HTTP
            let (data, response) = try await session.data(from: url)
            
            // Valida resposta HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Verifica status code (200-299 = sucesso)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // Decodifica JSON para array de Film
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
    
    // Busca detalhes de um filme específico por ID
    func fetchFilm(id: String) async throws -> Film {
        guard let url = URL(string: "\(baseURL)/films/\(id)") else {
            throw APIError.invalidURL
        }
        
        do {
            // Faz requisição HTTP
            let (data, response) = try await session.data(from: url)
            
            // Valida resposta HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Verifica status code (200-299 = sucesso)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // Decodifica JSON para Film
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
