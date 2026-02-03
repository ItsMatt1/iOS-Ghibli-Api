//
//  FilmListView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

struct FilmListView: View {
    @StateObject private var viewModel = FilmListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Carregando filmes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded(let films):
                    if films.isEmpty {
                        VStack {
                            Image(systemName: "film")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Nenhum filme encontrado")
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(films) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmRowView(film: film)
                            }
                        }
                    }
                    
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Erro ao carregar filmes")
                            .font(.headline)
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Tentar novamente") {
                            Task { @MainActor in
                                await viewModel.loadFilms()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Filmes Studio Ghibli")
            .task {
                await viewModel.loadFilms()
            }
        }
    }
}

struct FilmRowView: View {
    let film: Film
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(film.title)
                .font(.headline)
            Text("Ano: \(film.releaseDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FilmListView()
}
