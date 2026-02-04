//
//  FilmDetailView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

struct FilmDetailView: View {
    let filmId: String
    @StateObject private var viewModel = FilmDetailViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                // Indicador de carregamento
                ProgressView("Carregando detalhes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded(let film):
                // ScrollView com detalhes do filme
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Banner do filme (usa movieBanner ou image como fallback)
                        if let bannerURL = film.movieBanner ?? film.image {
                            AsyncImageView(
                                urlString: bannerURL,
                                placeholder: Image(systemName: "photo.artframe")
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        Text(film.title)
                            .font(.largeTitle)
                            .bold()
                        
                        Divider()
                        
                        // Informações principais do filme
                        DetailRow(label: "Ano de Lançamento", value: film.releaseDate)
                        DetailRow(label: "Diretor", value: film.director)
                        DetailRow(label: "Produtor", value: film.producer)
                        
                        Divider()
                        
                        // Descrição completa
                        Text("Descrição")
                            .font(.headline)
                        Text(film.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
            case .error(let message):
                // Estado de erro com opção de retry
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Erro ao carregar detalhes")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Tentar novamente") {
                        Task { @MainActor in
                            await viewModel.loadFilm(id: filmId)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        // Carrega detalhes quando a view aparece
        .task {
            await viewModel.loadFilm(id: filmId)
        }
    }
}

// Componente reutilizável para exibir label e valor
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.headline)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        FilmDetailView(filmId: "test-id")
    }
}
