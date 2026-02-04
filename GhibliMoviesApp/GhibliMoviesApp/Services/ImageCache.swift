//
//  ImageCache.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import UIKit

// Cache de imagens usando NSCache para armazenamento em memória
actor ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Configurar limites do cache
        cache.countLimit = 100 // Máximo de 100 imagens
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB de memória
    }
    
    // Recupera imagem do cache se existir
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // Armazena imagem no cache com cálculo de custo
    func setImage(_ image: UIImage, forKey key: String) {
        // Calcula o custo baseado no tamanho da imagem
        let cost = Int(image.size.width * image.size.height * 4) // 4 bytes por pixel (RGBA)
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
    
    // Remove uma imagem específica do cache
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    // Limpa todo o cache
    func clearCache() {
        cache.removeAllObjects()
    }
}
