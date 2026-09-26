//
//  BiologyFlashcardsView.swift
//  education
//

import SwiftUI

struct BiologyCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
    let color: Color
}

private let biologyCards: [BiologyCard] = [
    BiologyCard(name: "Plants",     subtitle: "Need sun, water, and soil",     emoji: "🌱", color: Color(red: 0.22, green: 0.62, blue: 0.32)),
    BiologyCard(name: "Animals",    subtitle: "Need food, water, and air",     emoji: "🐾", color: Color(red: 0.78, green: 0.42, blue: 0.12)),
    BiologyCard(name: "Humans",     subtitle: "Need food, water, and sleep",   emoji: "🧑", color: Color(red: 0.85, green: 0.55, blue: 0.22)),
    BiologyCard(name: "Living",     subtitle: "Grows and needs energy",        emoji: "🌳", color: Color(red: 0.18, green: 0.58, blue: 0.42)),
    BiologyCard(name: "Nonliving",  subtitle: "Doesn't grow or need food",     emoji: "🪨", color: Color(red: 0.52, green: 0.52, blue: 0.58)),
    BiologyCard(name: "Habitat",    subtitle: "Where living things live",      emoji: "🏞️", color: Color(red: 0.22, green: 0.68, blue: 0.62)),
    BiologyCard(name: "Sight",      subtitle: "You see with your eyes",        emoji: "👀", color: Color(red: 0.62, green: 0.28, blue: 0.68)),
    BiologyCard(name: "Hearing",    subtitle: "You hear with your ears",       emoji: "👂", color: Color(red: 0.42, green: 0.32, blue: 0.78)),
    BiologyCard(name: "Smell",      subtitle: "You smell with your nose",      emoji: "👃", color: Color(red: 0.72, green: 0.32, blue: 0.52)),
    BiologyCard(name: "Taste",      subtitle: "You taste with your tongue",    emoji: "👅", color: Color(red: 0.85, green: 0.38, blue: 0.32)),
    BiologyCard(name: "Touch",      subtitle: "You touch with your hands",     emoji: "✋", color: Color(red: 0.28, green: 0.55, blue: 0.68)),
]

struct BiologyFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = biologyCards[index]
        speech.speak("\(card.name). \(card.subtitle)")
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
                ForEach(biologyCards.indices, id: \.self) { index in
                    BiologyCardView(card: biologyCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == biologyCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(biologyCards.count)")
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

struct BiologyCardView: View {
    let card: BiologyCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(card.emoji)
                    .font(.system(size: 150))
                    .shadow(radius: 10)

                Text(card.name)
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text(card.subtitle)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.88))
                    .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    BiologyFlashcardsView()
}
