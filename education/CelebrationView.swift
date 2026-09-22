//
//  CelebrationView.swift
//  education
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let xFraction: CGFloat
    let delay: Double
    let duration: Double
    let rotation: Double
    let size: CGFloat
}

struct ConfettiView: View {
    @State private var animate = false

    private let pieces: [ConfettiPiece] = (0..<50).map { _ in
        ConfettiPiece(
            color: [Color.red, .orange, .yellow, .green, .blue, .purple, .pink].randomElement()!,
            xFraction: CGFloat.random(in: 0...1),
            delay: Double.random(in: 0...0.5),
            duration: Double.random(in: 1.8...2.8),
            rotation: Double.random(in: 0...360),
            size: CGFloat.random(in: 8...14)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 1.6)
                        .rotationEffect(.degrees(animate ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: piece.xFraction * geo.size.width,
                            y: animate ? geo.size.height + 40 : -40
                        )
                        .animation(.easeIn(duration: piece.duration).delay(piece.delay), value: animate)
                }
            }
            .onAppear { animate = true }
        }
        .allowsHitTesting(false)
    }
}

struct CelebrationOverlay: View {
    let isShowing: Bool

    var body: some View {
        if isShowing {
            ZStack {
                ConfettiView()

                VStack(spacing: 12) {
                    Text("🎉")
                        .font(.system(size: 76))
                    Text("Great Job!")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("You finished the deck!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(32)
                .background(.black.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 8)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .transition(.opacity.combined(with: .scale(scale: 0.85)))
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        CelebrationOverlay(isShowing: true)
    }
}
