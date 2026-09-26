//
//  ChemistryFlashcardsView.swift
//  education
//

import SwiftUI

struct ChemistryCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
    let color: Color
}

private let chemistryCards: [ChemistryCard] = [
    ChemistryCard(name: "Solid",    subtitle: "Has its own shape",              emoji: "🧊", color: Color(red: 0.22, green: 0.48, blue: 0.82)),
    ChemistryCard(name: "Liquid",   subtitle: "Takes the shape of its container", emoji: "💧", color: Color(red: 0.18, green: 0.62, blue: 0.78)),
    ChemistryCard(name: "Gas",      subtitle: "Spreads out to fill space",       emoji: "💨", color: Color(red: 0.62, green: 0.62, blue: 0.72)),
    ChemistryCard(name: "Melting",  subtitle: "A solid turns into a liquid",     emoji: "🔥", color: Color(red: 0.85, green: 0.42, blue: 0.15)),
    ChemistryCard(name: "Freezing", subtitle: "A liquid turns into a solid",     emoji: "❄️", color: Color(red: 0.28, green: 0.55, blue: 0.85)),
    ChemistryCard(name: "Mixing",   subtitle: "Combining two things together",   emoji: "🧪", color: Color(red: 0.42, green: 0.68, blue: 0.32)),
    ChemistryCard(name: "Fizzy",    subtitle: "Bubbles forming a gas",           emoji: "🫧", color: Color(red: 0.32, green: 0.72, blue: 0.62)),
]

struct ChemistryFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = chemistryCards[index]
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
                ForEach(chemistryCards.indices, id: \.self) { index in
                    ChemistryCardView(card: chemistryCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == chemistryCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(chemistryCards.count)")
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

struct ChemistryCardView: View {
    let card: ChemistryCard

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
    ChemistryFlashcardsView()
}
