//
//  SkeletonView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

// Componente de skeleton loading com animação shimmer
struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    // Gradiente para efeito shimmer
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.2),
                            Color.gray.opacity(0.4),
                            Color.gray.opacity(0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                // Animação de shimmer (desliza da esquerda para direita)
                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear {
            isAnimating = true
        }
    }
}

// Skeleton específico para imagens
struct SkeletonImageView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        SkeletonView()
            .frame(width: width, height: height)
    }
}

// Skeleton específico para texto
struct SkeletonText: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        SkeletonView()
            .frame(width: width, height: height)
    }
}
