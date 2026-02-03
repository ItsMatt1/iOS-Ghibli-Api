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
        HStack(spacing: 12) {
            // Thumbnail do filme
            AsyncImageView(
                urlString: film.image,
                placeholder: Image(systemName: "film.fill")
            )
            .frame(width: 80, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            // Informações do filme
            VStack(alignment: .leading, spacing: 8) {
                Text(film.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("Ano: \(film.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FilmListView()
}
