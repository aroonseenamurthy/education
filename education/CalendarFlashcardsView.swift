//
//  CalendarFlashcardsView.swift
//  education
//

import SwiftUI

enum CalendarCategory: String, CaseIterable, Identifiable {
    case days = "Days"
    case months = "Months"
    case seasons = "Seasons"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .days: return "📅"
        case .months: return "🗓️"
        case .seasons: return "🍂"
        }
    }

    var color: Color {
        switch self {
        case .days: return Color(red: 0.22, green: 0.55, blue: 0.82)
        case .months: return Color(red: 0.62, green: 0.32, blue: 0.72)
        case .seasons: return Color(red: 0.85, green: 0.52, blue: 0.15)
        }
    }
}

struct CalendarCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
}

private let dayCards: [CalendarCard] = [
    CalendarCard(name: "Sunday",    subtitle: "Day 1", emoji: "☀️"),
    CalendarCard(name: "Monday",    subtitle: "Day 2", emoji: "📚"),
    CalendarCard(name: "Tuesday",   subtitle: "Day 3", emoji: "🎨"),
    CalendarCard(name: "Wednesday", subtitle: "Day 4", emoji: "🔬"),
    CalendarCard(name: "Thursday",  subtitle: "Day 5", emoji: "🎵"),
    CalendarCard(name: "Friday",    subtitle: "Day 6", emoji: "🎉"),
    CalendarCard(name: "Saturday",  subtitle: "Day 7", emoji: "⚽"),
]

private let monthCards: [CalendarCard] = [
    CalendarCard(name: "January",   subtitle: "Month 1",  emoji: "❄️"),
    CalendarCard(name: "February",  subtitle: "Month 2",  emoji: "❤️"),
    CalendarCard(name: "March",     subtitle: "Month 3",  emoji: "🍀"),
    CalendarCard(name: "April",     subtitle: "Month 4",  emoji: "🌧️"),
    CalendarCard(name: "May",       subtitle: "Month 5",  emoji: "🌸"),
    CalendarCard(name: "June",      subtitle: "Month 6",  emoji: "☀️"),
    CalendarCard(name: "July",      subtitle: "Month 7",  emoji: "🎆"),
    CalendarCard(name: "August",    subtitle: "Month 8",  emoji: "🏖️"),
    CalendarCard(name: "September", subtitle: "Month 9",  emoji: "🍎"),
    CalendarCard(name: "October",   subtitle: "Month 10", emoji: "🎃"),
    CalendarCard(name: "November",  subtitle: "Month 11", emoji: "🦃"),
    CalendarCard(name: "December",  subtitle: "Month 12", emoji: "🎄"),
]

private let seasonCards: [CalendarCard] = [
    CalendarCard(name: "Winter", subtitle: "Cold and snowy",   emoji: "⛄"),
    CalendarCard(name: "Spring", subtitle: "Flowers bloom",    emoji: "🌷"),
    CalendarCard(name: "Summer", subtitle: "Hot and sunny",    emoji: "🌞"),
    CalendarCard(name: "Fall",   subtitle: "Leaves change color", emoji: "🍁"),
]

struct CalendarFlashcardsView: View {
    @State private var selectedCategory: CalendarCategory = .days
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private var cards: [CalendarCard] {
        switch selectedCategory {
        case .days: return dayCards
        case .months: return monthCards
        case .seasons: return seasonCards
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
                    CalendarCardView(card: cards[index], color: selectedCategory.color)
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
                    ForEach(CalendarCategory.allCases) { category in
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

struct CalendarCardView: View {
    let card: CalendarCard
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
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text(card.subtitle)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.88))
                    .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    CalendarFlashcardsView()
}
