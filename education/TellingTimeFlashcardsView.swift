//
//  TellingTimeFlashcardsView.swift
//  education
//

import SwiftUI

enum TimeCategory: String, CaseIterable, Identifiable {
    case oclock = "O'Clock"
    case halfPast = "Half Past"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .oclock: return "🕐"
        case .halfPast: return "🕜"
        }
    }

    var color: Color {
        switch self {
        case .oclock: return Color(red: 0.22, green: 0.48, blue: 0.78)
        case .halfPast: return Color(red: 0.62, green: 0.32, blue: 0.68)
        }
    }
}

struct TimeCard: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    let label: String
    let subtitle: String
}

private let oclockCards: [TimeCard] = [
    TimeCard(hour: 1,  minute: 0, label: "1:00",  subtitle: "Time for lunch"),
    TimeCard(hour: 2,  minute: 0, label: "2:00",  subtitle: "Time for a nap"),
    TimeCard(hour: 3,  minute: 0, label: "3:00",  subtitle: "Time for school"),
    TimeCard(hour: 4,  minute: 0, label: "4:00",  subtitle: "Time for a snack"),
    TimeCard(hour: 5,  minute: 0, label: "5:00",  subtitle: "Time to play"),
    TimeCard(hour: 6,  minute: 0, label: "6:00",  subtitle: "Time for dinner"),
    TimeCard(hour: 7,  minute: 0, label: "7:00",  subtitle: "Time for a bath"),
    TimeCard(hour: 8,  minute: 0, label: "8:00",  subtitle: "Time for bed"),
    TimeCard(hour: 9,  minute: 0, label: "9:00",  subtitle: "Time to wake up"),
    TimeCard(hour: 10, minute: 0, label: "10:00", subtitle: "Time for breakfast"),
    TimeCard(hour: 11, minute: 0, label: "11:00", subtitle: "Time to brush teeth"),
    TimeCard(hour: 12, minute: 0, label: "12:00", subtitle: "Noon time"),
]

private let halfPastCards: [TimeCard] = [
    TimeCard(hour: 1,  minute: 30, label: "1:30",  subtitle: "Half past one"),
    TimeCard(hour: 2,  minute: 30, label: "2:30",  subtitle: "Half past two"),
    TimeCard(hour: 3,  minute: 30, label: "3:30",  subtitle: "Half past three"),
    TimeCard(hour: 4,  minute: 30, label: "4:30",  subtitle: "Half past four"),
    TimeCard(hour: 5,  minute: 30, label: "5:30",  subtitle: "Half past five"),
    TimeCard(hour: 6,  minute: 30, label: "6:30",  subtitle: "Half past six"),
    TimeCard(hour: 7,  minute: 30, label: "7:30",  subtitle: "Half past seven"),
    TimeCard(hour: 8,  minute: 30, label: "8:30",  subtitle: "Half past eight"),
    TimeCard(hour: 9,  minute: 30, label: "9:30",  subtitle: "Half past nine"),
    TimeCard(hour: 10, minute: 30, label: "10:30", subtitle: "Half past ten"),
    TimeCard(hour: 11, minute: 30, label: "11:30", subtitle: "Half past eleven"),
    TimeCard(hour: 12, minute: 30, label: "12:30", subtitle: "Half past twelve"),
]

struct TellingTimeFlashcardsView: View {
    @State private var selectedCategory: TimeCategory = .oclock
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private var cards: [TimeCard] {
        switch selectedCategory {
        case .oclock: return oclockCards
        case .halfPast: return halfPastCards
        }
    }

    private func speakCard(_ index: Int) {
        guard cards.indices.contains(index) else { return }
        let card = cards[index]
        speech.speak("It's \(card.label). \(card.subtitle).")
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
                    TimeCardView(card: cards[index], color: selectedCategory.color)
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
                    ForEach(TimeCategory.allCases) { category in
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

struct TimeCardView: View {
    let card: TimeCard
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
                ClockFaceView(hour: card.hour, minute: card.minute)

                Text(card.label)
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

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
    TellingTimeFlashcardsView()
}
