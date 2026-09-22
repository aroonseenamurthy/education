//
//  SightWordsFlashcardsView.swift
//  education
//

import SwiftUI

struct SightWordCard: Identifiable {
    let id = UUID()
    let word: String
    let example: String
    let emoji: String
    let color: Color
}

private let sightWordCards: [SightWordCard] = [
    SightWordCard(word: "the",  example: "the dog",     emoji: "🐶", color: Color(red: 0.22, green: 0.55, blue: 0.82)),
    SightWordCard(word: "and",  example: "cat and dog",  emoji: "🐱", color: Color(red: 0.88, green: 0.42, blue: 0.18)),
    SightWordCard(word: "a",    example: "a ball",       emoji: "⚽", color: Color(red: 0.32, green: 0.62, blue: 0.42)),
    SightWordCard(word: "is",   example: "it is big",    emoji: "🐘", color: Color(red: 0.55, green: 0.32, blue: 0.68)),
    SightWordCard(word: "to",   example: "go to bed",    emoji: "🛏️", color: Color(red: 0.78, green: 0.52, blue: 0.15)),
    SightWordCard(word: "I",    example: "I can run",    emoji: "🏃", color: Color(red: 0.85, green: 0.22, blue: 0.35)),
    SightWordCard(word: "you",  example: "you and me",   emoji: "🙋", color: Color(red: 0.22, green: 0.58, blue: 0.68)),
    SightWordCard(word: "see",  example: "I see you",    emoji: "👀", color: Color(red: 0.42, green: 0.48, blue: 0.78)),
    SightWordCard(word: "big",  example: "big elephant",  emoji: "🐘", color: Color(red: 0.68, green: 0.38, blue: 0.22)),
    SightWordCard(word: "small",example: "small mouse",  emoji: "🐭", color: Color(red: 0.58, green: 0.42, blue: 0.72)),
    SightWordCard(word: "run",  example: "run fast",     emoji: "🏃", color: Color(red: 0.32, green: 0.68, blue: 0.55)),
    SightWordCard(word: "jump", example: "jump high",    emoji: "🤸", color: Color(red: 0.88, green: 0.32, blue: 0.42)),
    SightWordCard(word: "cat",  example: "the cat sat",  emoji: "🐱", color: Color(red: 0.85, green: 0.55, blue: 0.15)),
    SightWordCard(word: "dog",  example: "the dog ran",  emoji: "🐶", color: Color(red: 0.72, green: 0.55, blue: 0.42)),
    SightWordCard(word: "sun",  example: "the sun is hot", emoji: "☀️", color: Color(red: 0.92, green: 0.72, blue: 0.08)),
    SightWordCard(word: "hat",  example: "a red hat",    emoji: "🎩", color: Color(red: 0.62, green: 0.28, blue: 0.72)),
    SightWordCard(word: "yes",  example: "yes I can",    emoji: "✅", color: Color(red: 0.22, green: 0.68, blue: 0.35)),
    SightWordCard(word: "no",   example: "no thank you", emoji: "🙅", color: Color(red: 0.88, green: 0.22, blue: 0.22)),
    SightWordCard(word: "up",   example: "look up",      emoji: "⬆️", color: Color(red: 0.28, green: 0.52, blue: 0.88)),
    SightWordCard(word: "down", example: "sit down",     emoji: "⬇️", color: Color(red: 0.45, green: 0.42, blue: 0.62)),
]

struct SightWordsFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = sightWordCards[index]
        speech.speak("\(card.word). \(card.example)")
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
                ForEach(sightWordCards.indices, id: \.self) { index in
                    SightWordCardView(card: sightWordCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == sightWordCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(sightWordCards.count)")
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

struct SightWordCardView: View {
    let card: SightWordCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(card.word)
                    .font(.system(size: 88, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

                Text(card.emoji)
                    .font(.system(size: 130))
                    .shadow(radius: 10)

                Text(card.example)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.88))
                    .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    SightWordsFlashcardsView()
}
