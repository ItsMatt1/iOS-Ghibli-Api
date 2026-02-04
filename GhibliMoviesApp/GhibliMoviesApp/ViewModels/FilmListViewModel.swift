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
    private var allFilms: [Film] = [] // Lista completa de filmes (antes do filtro)
    
    // Computed property que filtra filmes baseado na busca
    var filteredFilms: [Film] {
        if searchText.isEmpty {
            return allFilms
        }
        
        // Busca case-insensitive em múltiplos campos
        return allFilms.filter { film in
            film.title.localizedCaseInsensitiveContains(searchText) ||
            film.originalTitle.localizedCaseInsensitiveContains(searchText) ||
            film.director.localizedCaseInsensitiveContains(searchText) ||
            film.releaseDate.contains(searchText)
        }
    }
    
    // Carrega lista de filmes da API
    func loadFilms() async {
        state = .loading
        
        do {
            // Chamada ao actor - automaticamente isolada (thread-safe)
            let films = try await apiService.fetchFilms()
            allFilms = films
            state = .loaded(films)
        } catch {
            // Extrai mensagem de erro localizada
            let errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }
    
    // Atualiza lista de filmes (usado no pull-to-refresh)
    func refreshFilms() async {
        // Não muda estado para loading para manter lista visível durante refresh
        do {
            let films = try await apiService.fetchFilms()
            allFilms = films
            // Só atualiza o estado se estava em loaded
            if case .loaded = state {
                state = .loaded(films)
            }
        } catch {
            // Em caso de erro durante refresh, mantém o estado atual
            // (poderia mostrar um toast ou alerta aqui)
        }
    }
}

// Enum genérico para representar estados da UI
enum ViewState<T> {
    case loading // Carregando dados
    case loaded(T) // Dados carregados com sucesso
    case error(String) // Erro com mensagem
}
