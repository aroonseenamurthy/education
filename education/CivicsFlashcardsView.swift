//
//  CivicsFlashcardsView.swift
//  education
//

import SwiftUI

struct CivicsCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
    let color: Color
}

private let civicsCards: [CivicsCard] = [
    CivicsCard(name: "American Flag",       subtitle: "Symbol of our country",           emoji: "🇺🇸", color: Color(red: 0.72, green: 0.22, blue: 0.28)),
    CivicsCard(name: "The President",       subtitle: "Leader of our country",           emoji: "🎩", color: Color(red: 0.22, green: 0.42, blue: 0.68)),
    CivicsCard(name: "Voting",              subtitle: "How we choose our leaders",        emoji: "🗳️", color: Color(red: 0.32, green: 0.58, blue: 0.42)),
    CivicsCard(name: "Rules & Laws",        subtitle: "Keep everyone safe and fair",      emoji: "⚖️", color: Color(red: 0.42, green: 0.32, blue: 0.68)),
    CivicsCard(name: "Community Helpers",   subtitle: "People who help our community",    emoji: "👮", color: Color(red: 0.22, green: 0.48, blue: 0.78)),
    CivicsCard(name: "The White House",     subtitle: "Where the President works",        emoji: "🏛️", color: Color(red: 0.52, green: 0.52, blue: 0.58)),
    CivicsCard(name: "Statue of Liberty",   subtitle: "Symbol of freedom",                emoji: "🗽", color: Color(red: 0.28, green: 0.58, blue: 0.55)),
    CivicsCard(name: "Bald Eagle",          subtitle: "Our national bird",                emoji: "🦅", color: Color(red: 0.55, green: 0.42, blue: 0.22)),
    CivicsCard(name: "Pledge of Allegiance",subtitle: "Our promise to the country",       emoji: "🫡", color: Color(red: 0.22, green: 0.42, blue: 0.62)),
    CivicsCard(name: "National Anthem",     subtitle: "Our country's song",               emoji: "🎵", color: Color(red: 0.62, green: 0.28, blue: 0.42)),
]

struct CivicsFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = civicsCards[index]
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
                ForEach(civicsCards.indices, id: \.self) { index in
                    CivicsCardView(card: civicsCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == civicsCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(civicsCards.count)")
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

struct CivicsCardView: View {
    let card: CivicsCard

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
                    .font(.system(size: 40, weight: .black, design: .rounded))
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
    CivicsFlashcardsView()
}
