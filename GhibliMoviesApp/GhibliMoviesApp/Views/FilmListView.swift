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
            VStack(spacing: 0) {
                // Barra de busca
                if case .loaded = viewModel.state {
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                
                // Conteúdo principal
                Group {
                    switch viewModel.state {
                    case .loading:
                        List(0..<5, id: \.self) { _ in
                            FilmRowSkeletonView()
                        }
                        .disabled(true)
                        
                    case .loaded:
                        let films = viewModel.filteredFilms
                        if films.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: viewModel.searchText.isEmpty ? "film" : "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text(viewModel.searchText.isEmpty ? "Nenhum filme encontrado" : "Nenhum resultado encontrado")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                if !viewModel.searchText.isEmpty {
                                    Text("Tente buscar por outro termo")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(films) { film in
                                NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                    FilmRowView(film: film)
                                }
                            }
                            .refreshable {
                                await viewModel.refreshFilms()
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
            }
            .navigationTitle("Filmes Studio Ghibli")
            .task {
                await viewModel.loadFilms()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar filmes...", text: $text)
                .textFieldStyle(.plain)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
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

struct FilmRowSkeletonView: View {
    var body: some View {
        HStack(spacing: 12) {
            // Skeleton para thumbnail
            SkeletonImageView(width: 80, height: 120)
            
            // Skeleton para informações
            VStack(alignment: .leading, spacing: 8) {
                SkeletonText(width: 200, height: 20)
                SkeletonText(width: 100, height: 16)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FilmListView()
}
