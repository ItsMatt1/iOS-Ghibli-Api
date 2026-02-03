//
//  FilmListViewModel.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

@MainActor
class FilmListViewModel: ObservableObject {
    @Published var state: ViewState<[Film]> = .loading
    
    private let apiService = GhibliAPIService()
    
    func loadFilms() async {
        state = .loading
        
        do {
            let films = try await apiService.fetchFilms()
            state = .loaded(films)
        } catch {
            let errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }
}

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(String)
}
