//
//  HistoryFlashcardsView.swift
//  education
//

import SwiftUI

struct HistoryCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
    let symbol: String
    let color: Color
}

private let historyCards: [HistoryCard] = [
    HistoryCard(name: "George Washington",  subtitle: "First President of the USA",       emoji: "🎩", symbol: "building.columns.fill", color: Color(red: 0.22, green: 0.42, blue: 0.68)),
    HistoryCard(name: "Abraham Lincoln",     subtitle: "Helped end slavery",               emoji: "📜", symbol: "doc.text.fill",         color: Color(red: 0.42, green: 0.32, blue: 0.28)),
    HistoryCard(name: "Martin Luther King",  subtitle: "Fought for equal rights for all",  emoji: "✊", symbol: "hand.raised.fill",      color: Color(red: 0.62, green: 0.28, blue: 0.32)),
    HistoryCard(name: "Betsy Ross",          subtitle: "Sewed the first American flag",    emoji: "🇺🇸", symbol: "flag.fill",            color: Color(red: 0.72, green: 0.22, blue: 0.28)),
    HistoryCard(name: "Rosa Parks",          subtitle: "Stood up for her rights on a bus", emoji: "🚌", symbol: "bus.fill",              color: Color(red: 0.55, green: 0.32, blue: 0.62)),
    HistoryCard(name: "Neil Armstrong",      subtitle: "First person to walk on the moon", emoji: "🚀", symbol: "moon.stars.fill",       color: Color(red: 0.28, green: 0.38, blue: 0.55)),
    HistoryCard(name: "Benjamin Franklin",   subtitle: "Inventor and Founding Father",     emoji: "⚡", symbol: "bolt.fill",             color: Color(red: 0.68, green: 0.52, blue: 0.15)),
    HistoryCard(name: "Amelia Earhart",      subtitle: "Famous pilot who flew across the ocean", emoji: "✈️", symbol: "airplane",       color: Color(red: 0.22, green: 0.58, blue: 0.68)),
]

struct HistoryFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = historyCards[index]
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
                ForEach(historyCards.indices, id: \.self) { index in
                    HistoryCardView(card: historyCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == historyCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(historyCards.count)")
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

struct HistoryCardView: View {
    let card: HistoryCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Image(systemName: card.symbol)
                .font(.system(size: 320))
                .foregroundStyle(.white.opacity(0.14))
                .rotationEffect(.degrees(-10))
                .offset(x: 30, y: -30)
                .allowsHitTesting(false)

            VStack(spacing: 20) {
                Text(card.emoji)
                    .font(.system(size: 150))
                    .shadow(radius: 10)

                Text(card.name)
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

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
    HistoryFlashcardsView()
}
