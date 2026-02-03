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
                ProgressView("Carregando detalhes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded(let film):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(film.title)
                            .font(.largeTitle)
                            .bold()
                        
                        Divider()
                        
                        DetailRow(label: "Ano de Lançamento", value: film.releaseDate)
                        DetailRow(label: "Diretor", value: film.director)
                        DetailRow(label: "Produtor", value: film.producer)
                        
                        Divider()
                        
                        Text("Descrição")
                            .font(.headline)
                        Text(film.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
            case .error(let message):
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
        .task {
            await viewModel.loadFilm(id: filmId)
        }
    }
}

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
