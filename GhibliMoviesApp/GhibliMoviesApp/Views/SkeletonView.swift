//
//  SkeletonView.swift
//  GhibliMoviesApp
//
//  Created by Matheus de Moura Rosa on 03/02/26.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8)
                .fill(
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

struct SkeletonImageView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        SkeletonView()
            .frame(width: width, height: height)
    }
}

struct SkeletonText: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        SkeletonView()
            .frame(width: width, height: height)
    }
}
