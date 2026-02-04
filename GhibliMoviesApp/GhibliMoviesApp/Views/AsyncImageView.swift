//
//  AsyncImageView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

// Componente para carregar imagens de forma assíncrona com cache
struct AsyncImageView: View {
    let urlString: String?
    let placeholder: Image
    
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasError = false
    
    private let imageCache = ImageCache.shared
    
    init(urlString: String?, placeholder: Image = Image(systemName: "photo")) {
        self.urlString = urlString
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                // Imagem carregada com sucesso
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                // Skeleton loading durante carregamento
                SkeletonView()
            } else {
                // Placeholder em caso de erro ou URL inválida
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        // Carrega imagem quando a view aparece
        .task {
            await loadImage()
        }
    }
    
    // Carrega imagem da URL ou do cache
    @MainActor
    private func loadImage() async {
        // Valida URL
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            isLoading = false
            hasError = true
            return
        }
        
        // Verifica cache primeiro (evita requisições desnecessárias)
        if let cachedImage = await imageCache.getImage(forKey: urlString) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        isLoading = true
        hasError = false
        
        do {
            // Faz requisição HTTP para baixar imagem
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                // Salva no cache para uso futuro
                await imageCache.setImage(uiImage, forKey: urlString)
                self.image = uiImage
                self.isLoading = false
            } else {
                // Dados não são uma imagem válida
                self.isLoading = false
                self.hasError = true
            }
        } catch {
            // Erro de rede
            self.isLoading = false
            self.hasError = true
        }
    }
}
