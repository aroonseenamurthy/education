//
//  SocialSkillsFlashcardsView.swift
//  education
//

import SwiftUI

enum SocialSkillsCategory: String, CaseIterable, Identifiable {
    case manners = "Manners"
    case feelings = "Feelings"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .manners: return "🤝"
        case .feelings: return "😊"
        }
    }

    var color: Color {
        switch self {
        case .manners: return Color(red: 0.22, green: 0.58, blue: 0.68)
        case .feelings: return Color(red: 0.72, green: 0.42, blue: 0.18)
        }
    }
}

struct SocialSkillsCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
}

private let mannersCards: [SocialSkillsCard] = [
    SocialSkillsCard(name: "Please",      subtitle: "Ask nicely for things",            emoji: "🙏"),
    SocialSkillsCard(name: "Thank You",    subtitle: "Show you're grateful",             emoji: "😊"),
    SocialSkillsCard(name: "Sorry",        subtitle: "Say it when you make a mistake",   emoji: "😔"),
    SocialSkillsCard(name: "Sharing",      subtitle: "Give others a turn too",           emoji: "🤝"),
    SocialSkillsCard(name: "Taking Turns", subtitle: "Wait patiently for your turn",     emoji: "🔄"),
    SocialSkillsCard(name: "Listening",    subtitle: "Pay attention when others speak",  emoji: "👂"),
]

private let feelingsCards: [SocialSkillsCard] = [
    SocialSkillsCard(name: "Happy",   subtitle: "Feeling joyful and glad",       emoji: "😄"),
    SocialSkillsCard(name: "Sad",     subtitle: "Feeling down or unhappy",       emoji: "😢"),
    SocialSkillsCard(name: "Angry",   subtitle: "Feeling upset or mad",          emoji: "😠"),
    SocialSkillsCard(name: "Scared",  subtitle: "Feeling afraid",                emoji: "😨"),
    SocialSkillsCard(name: "Excited", subtitle: "Feeling very happy and eager",  emoji: "🤩"),
    SocialSkillsCard(name: "Calm",    subtitle: "Feeling peaceful and relaxed",  emoji: "😌"),
]

struct SocialSkillsFlashcardsView: View {
    @State private var selectedCategory: SocialSkillsCategory = .manners
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private var cards: [SocialSkillsCard] {
        switch selectedCategory {
        case .manners: return mannersCards
        case .feelings: return feelingsCards
        }
    }

    private func speakCard(_ index: Int) {
        guard cards.indices.contains(index) else { return }
        let card = cards[index]
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
                ForEach(cards.indices, id: \.self) { index in
                    SocialSkillsCardView(card: cards[index], color: selectedCategory.color)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == cards.count - 1 { celebrate() }
            }
            .onChange(of: selectedCategory) { _, _ in
                currentIndex = 0
                speakCard(0)
            }

            VStack(spacing: 14) {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(SocialSkillsCategory.allCases) { category in
                        Text("\(category.emoji) \(category.rawValue)").tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)

                HStack {
                    Spacer()
                    Text("\(currentIndex + 1)  of  \(cards.count)")
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
            }
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

struct SocialSkillsCardView: View {
    let card: SocialSkillsCard
    let color: Color

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [color, color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(card.emoji)
                    .font(.system(size: 150))
                    .shadow(radius: 10)

                Text(card.name)
                    .font(.system(size: 48, weight: .black, design: .rounded))
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
    SocialSkillsFlashcardsView()
}
