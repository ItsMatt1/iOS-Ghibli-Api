//
//  FilmDetailViewModel.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

// Swift 6: ObservableObject tem Default Actor Isolation no MainActor
@MainActor
class FilmDetailViewModel: ObservableObject {
    @Published var state: ViewState<Film> = .loading
    
    private let apiService = GhibliAPIService()
    
    // Carrega detalhes de um filme específico
    func loadFilm(id: String) async {
        state = .loading
        
        do {
            // Chamada ao actor - automaticamente isolada (thread-safe)
            let film = try await apiService.fetchFilm(id: id)
            state = .loaded(film)
        } catch {
            // Extrai mensagem de erro localizada
            let errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }
}
