//
//  AsyncImageView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String?
    let placeholder: Image
    
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasError = false
    
    init(urlString: String?, placeholder: Image = Image(systemName: "photo")) {
        self.urlString = urlString
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.3))
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .task {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            isLoading = false
            hasError = true
            return
        }
        
        isLoading = true
        hasError = false
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
                self.isLoading = false
            } else {
                self.isLoading = false
                self.hasError = true
            }
        } catch {
            self.isLoading = false
            self.hasError = true
        }
    }
}
