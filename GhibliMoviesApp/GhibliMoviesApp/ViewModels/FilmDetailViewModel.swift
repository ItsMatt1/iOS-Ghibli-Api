//
//  FilmDetailViewModel.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

@MainActor
class FilmDetailViewModel: ObservableObject {
    @Published var state: ViewState<Film> = .loading
    
    private let apiService = GhibliAPIService()
    
    func loadFilm(id: String) async {
        state = .loading
        
        do {
            let film = try await apiService.fetchFilm(id: id)
            state = .loaded(film)
        } catch {
            let errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }
}
