//
//  SplashScreenView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App Icon/Logo placeholder
                Image(systemName: "gift.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                // App Name
                Text("FreeStuff")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(0.5), value: showContent)
                
                // Tagline
                Text("Share what you don't need")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
                
                // Loading indicator
                if showContent {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .animation(.easeInOut(duration: 0.5).delay(1.0), value: showContent)
                }
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation {
                showContent = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
