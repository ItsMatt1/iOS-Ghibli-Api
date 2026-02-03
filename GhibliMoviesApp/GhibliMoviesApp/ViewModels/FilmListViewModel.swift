//
//  FilmListViewModel.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import Foundation

// Swift 6: ObservableObject tem Default Actor Isolation no MainActor
@MainActor
class FilmListViewModel: ObservableObject {
    @Published var state: ViewState<[Film]> = .loading
    @Published var searchText: String = ""
    
    private let apiService = GhibliAPIService()
    private var allFilms: [Film] = []
    
    var filteredFilms: [Film] {
        if searchText.isEmpty {
            return allFilms
        }
        
        return allFilms.filter { film in
            film.title.localizedCaseInsensitiveContains(searchText) ||
            film.originalTitle.localizedCaseInsensitiveContains(searchText) ||
            film.director.localizedCaseInsensitiveContains(searchText) ||
            film.releaseDate.contains(searchText)
        }
    }
    
    func loadFilms() async {
        state = .loading
        
        do {
            // Chamada ao actor - automaticamente isolada
            let films = try await apiService.fetchFilms()
            allFilms = films
            state = .loaded(films)
        } catch {
            let errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }
    
    func refreshFilms() async {
        // Para pull-to-refresh, não mudamos o estado para loading
        // para manter a lista visível durante o refresh
        do {
            let films = try await apiService.fetchFilms()
            allFilms = films
            // Só atualiza o estado se estava em loaded
            if case .loaded = state {
                state = .loaded(films)
            }
        } catch {
            // Em caso de erro durante refresh, mantém o estado atual
            // mas poderia mostrar um toast ou alerta
        }
    }
}

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(String)
}
