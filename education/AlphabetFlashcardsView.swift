//
//  AlphabetFlashcardsView.swift
//  education
//

import SwiftUI

struct AlphabetCard: Identifiable {
    let id = UUID()
    let letter: String
    let word: String
    let emoji: String
    let color: Color
}

private let alphabetCards: [AlphabetCard] = [
    AlphabetCard(letter: "A", word: "Apple",     emoji: "🍎", color: Color(red: 0.92, green: 0.28, blue: 0.28)),
    AlphabetCard(letter: "B", word: "Balloon",   emoji: "🎈", color: Color(red: 0.28, green: 0.50, blue: 0.92)),
    AlphabetCard(letter: "C", word: "Cat",       emoji: "🐱", color: Color(red: 0.92, green: 0.58, blue: 0.18)),
    AlphabetCard(letter: "D", word: "Dog",       emoji: "🐶", color: Color(red: 0.30, green: 0.72, blue: 0.40)),
    AlphabetCard(letter: "E", word: "Elephant",  emoji: "🐘", color: Color(red: 0.55, green: 0.38, blue: 0.82)),
    AlphabetCard(letter: "F", word: "Fish",      emoji: "🐟", color: Color(red: 0.20, green: 0.62, blue: 0.85)),
    AlphabetCard(letter: "G", word: "Grapes",    emoji: "🍇", color: Color(red: 0.52, green: 0.28, blue: 0.72)),
    AlphabetCard(letter: "H", word: "Horse",     emoji: "🐴", color: Color(red: 0.78, green: 0.48, blue: 0.22)),
    AlphabetCard(letter: "I", word: "Ice Cream", emoji: "🍦", color: Color(red: 0.92, green: 0.42, blue: 0.62)),
    AlphabetCard(letter: "J", word: "Jellyfish", emoji: "🪼", color: Color(red: 0.32, green: 0.62, blue: 0.78)),
    AlphabetCard(letter: "K", word: "Kite",      emoji: "🪁", color: Color(red: 0.88, green: 0.32, blue: 0.32)),
    AlphabetCard(letter: "L", word: "Lion",      emoji: "🦁", color: Color(red: 0.92, green: 0.62, blue: 0.12)),
    AlphabetCard(letter: "M", word: "Monkey",    emoji: "🐵", color: Color(red: 0.68, green: 0.42, blue: 0.28)),
    AlphabetCard(letter: "N", word: "Nest",      emoji: "🪺", color: Color(red: 0.38, green: 0.68, blue: 0.42)),
    AlphabetCard(letter: "O", word: "Orange",    emoji: "🍊", color: Color(red: 0.92, green: 0.52, blue: 0.12)),
    AlphabetCard(letter: "P", word: "Penguin",   emoji: "🐧", color: Color(red: 0.32, green: 0.52, blue: 0.88)),
    AlphabetCard(letter: "Q", word: "Queen",     emoji: "👑", color: Color(red: 0.68, green: 0.32, blue: 0.78)),
    AlphabetCard(letter: "R", word: "Rainbow",   emoji: "🌈", color: Color(red: 0.88, green: 0.28, blue: 0.52)),
    AlphabetCard(letter: "S", word: "Sun",       emoji: "☀️", color: Color(red: 0.92, green: 0.72, blue: 0.08)),
    AlphabetCard(letter: "T", word: "Tiger",     emoji: "🐯", color: Color(red: 0.88, green: 0.48, blue: 0.18)),
    AlphabetCard(letter: "U", word: "Umbrella",  emoji: "☂️", color: Color(red: 0.28, green: 0.58, blue: 0.82)),
    AlphabetCard(letter: "V", word: "Volcano",   emoji: "🌋", color: Color(red: 0.78, green: 0.22, blue: 0.22)),
    AlphabetCard(letter: "W", word: "Whale",     emoji: "🐋", color: Color(red: 0.22, green: 0.48, blue: 0.82)),
    AlphabetCard(letter: "X", word: "Xylophone", emoji: "🎵", color: Color(red: 0.62, green: 0.28, blue: 0.72)),
    AlphabetCard(letter: "Y", word: "Yak",       emoji: "🦬", color: Color(red: 0.58, green: 0.72, blue: 0.28)),
    AlphabetCard(letter: "Z", word: "Zebra",     emoji: "🦓", color: Color(red: 0.32, green: 0.32, blue: 0.32)),
]

struct AlphabetFlashcardsView: View {
    @State private var currentIndex = 0
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = alphabetCards[index]
        speech.speakAlphabetCard(letter: card.letter, word: card.word)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(alphabetCards.indices, id: \.self) { index in
                    AlphabetCardView(card: alphabetCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in speakCard(newIndex) }

            // Progress + replay row
            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(alphabetCards.count)")
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
    }
}

struct AlphabetCardView: View {
    let card: AlphabetCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack(alignment: .lastTextBaseline, spacing: 12) {
                    Text(card.letter.uppercased())
                        .font(.system(size: 120, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text(card.letter.lowercased())
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

                Text(card.emoji)
                    .font(.system(size: 180))
                    .shadow(radius: 10)

                Text(card.word)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    AlphabetFlashcardsView()
}
