//
//  ColorsFlashcardsView.swift
//  education
//

import SwiftUI

struct ColorCard: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let swatch: Color           // actual color shown in the circle
    let background: [Color]     // card gradient
    let darkText: Bool          // use dark text on light backgrounds
}

private let colorCards: [ColorCard] = [
    ColorCard(name: "Red",    emoji: "🍎",
              swatch: Color(red: 0.90, green: 0.15, blue: 0.15),
              background: [Color(red: 0.85, green: 0.18, blue: 0.18), Color(red: 0.65, green: 0.10, blue: 0.10)],
              darkText: false),
    ColorCard(name: "Orange", emoji: "🍊",
              swatch: Color(red: 1.00, green: 0.55, blue: 0.10),
              background: [Color(red: 0.95, green: 0.50, blue: 0.10), Color(red: 0.80, green: 0.35, blue: 0.05)],
              darkText: false),
    ColorCard(name: "Yellow", emoji: "🌻",
              swatch: Color(red: 1.00, green: 0.88, blue: 0.00),
              background: [Color(red: 0.95, green: 0.80, blue: 0.08), Color(red: 0.88, green: 0.68, blue: 0.02)],
              darkText: true),
    ColorCard(name: "Green",  emoji: "🌿",
              swatch: Color(red: 0.15, green: 0.72, blue: 0.28),
              background: [Color(red: 0.18, green: 0.68, blue: 0.28), Color(red: 0.10, green: 0.50, blue: 0.18)],
              darkText: false),
    ColorCard(name: "Blue",   emoji: "🌊",
              swatch: Color(red: 0.15, green: 0.42, blue: 0.92),
              background: [Color(red: 0.18, green: 0.42, blue: 0.88), Color(red: 0.10, green: 0.28, blue: 0.72)],
              darkText: false),
    ColorCard(name: "Purple", emoji: "🍇",
              swatch: Color(red: 0.55, green: 0.18, blue: 0.82),
              background: [Color(red: 0.52, green: 0.18, blue: 0.78), Color(red: 0.38, green: 0.10, blue: 0.60)],
              darkText: false),
    ColorCard(name: "Pink",   emoji: "🌸",
              swatch: Color(red: 0.98, green: 0.45, blue: 0.68),
              background: [Color(red: 0.92, green: 0.38, blue: 0.62), Color(red: 0.80, green: 0.25, blue: 0.52)],
              darkText: false),
    ColorCard(name: "Brown",  emoji: "🐻",
              swatch: Color(red: 0.62, green: 0.35, blue: 0.18),
              background: [Color(red: 0.58, green: 0.32, blue: 0.15), Color(red: 0.42, green: 0.22, blue: 0.08)],
              darkText: false),
    ColorCard(name: "Black",  emoji: "🐼",
              swatch: Color(red: 0.10, green: 0.10, blue: 0.12),
              background: [Color(red: 0.20, green: 0.20, blue: 0.26), Color(red: 0.10, green: 0.10, blue: 0.15)],
              darkText: false),
    ColorCard(name: "White",  emoji: "⛄",
              swatch: Color(red: 0.98, green: 0.98, blue: 1.00),
              background: [Color(red: 0.72, green: 0.78, blue: 0.95), Color(red: 0.58, green: 0.65, blue: 0.88)],
              darkText: false),
    ColorCard(name: "Gray",   emoji: "🐘",
              swatch: Color(red: 0.58, green: 0.60, blue: 0.64),
              background: [Color(red: 0.52, green: 0.54, blue: 0.60), Color(red: 0.36, green: 0.38, blue: 0.44)],
              darkText: false),
    ColorCard(name: "Gold",   emoji: "🏆",
              swatch: Color(red: 1.00, green: 0.82, blue: 0.10),
              background: [Color(red: 0.88, green: 0.68, blue: 0.08), Color(red: 0.72, green: 0.52, blue: 0.02)],
              darkText: false),
]

struct ColorsFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        speech.speak(colorCards[index].name)
    }

    private func celebrate() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showCelebration = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) { showCelebration = false }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(colorCards.indices, id: \.self) { index in
                    ColorCardView(card: colorCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == colorCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(colorCards.count)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
                Button { speakCard(currentIndex) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.white.opacity(0.25))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button { speech.stop(); dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.25))
                    .clipShape(Circle())
            }
            .padding(.top, 56)
            .padding(.leading, 20)
        }
        .overlay {
            CelebrationOverlay(isShowing: showCelebration)
        }
    }
}

struct ColorCardView: View {
    let card: ColorCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: card.background,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text(card.name)
                    .font(.system(size: 80, weight: .black, design: .rounded))
                    .foregroundStyle(card.darkText ? Color(red: 0.18, green: 0.18, blue: 0.18) : .white)
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)

                // Color swatch circle
                Circle()
                    .fill(card.swatch)
                    .frame(width: 210, height: 210)
                    .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 5))
                    .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 6)

                Text(card.emoji)
                    .font(.system(size: 80))
                    .shadow(radius: 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    ColorsFlashcardsView()
}
