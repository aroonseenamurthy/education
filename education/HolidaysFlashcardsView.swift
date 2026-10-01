//
//  HolidaysFlashcardsView.swift
//  education
//

import SwiftUI

struct HolidayCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let emoji: String
    let color: Color
}

private let holidayCards: [HolidayCard] = [
    HolidayCard(name: "New Year's Day",   subtitle: "A fresh start on January 1st",        emoji: "🎉", color: Color(red: 0.42, green: 0.32, blue: 0.78)),
    HolidayCard(name: "Valentine's Day",  subtitle: "Share love on February 14th",          emoji: "💝", color: Color(red: 0.85, green: 0.28, blue: 0.42)),
    HolidayCard(name: "St. Patrick's Day", subtitle: "Wear green on March 17th",            emoji: "🍀", color: Color(red: 0.18, green: 0.62, blue: 0.32)),
    HolidayCard(name: "Easter",            subtitle: "Egg hunts to celebrate spring",        emoji: "🐰", color: Color(red: 0.72, green: 0.52, blue: 0.78)),
    HolidayCard(name: "Mother's Day",      subtitle: "A day to celebrate moms",              emoji: "💐", color: Color(red: 0.88, green: 0.42, blue: 0.58)),
    HolidayCard(name: "Father's Day",      subtitle: "A day to celebrate dads",              emoji: "👔", color: Color(red: 0.22, green: 0.48, blue: 0.68)),
    HolidayCard(name: "Independence Day",  subtitle: "Fireworks on July 4th",                emoji: "🎆", color: Color(red: 0.72, green: 0.22, blue: 0.28)),
    HolidayCard(name: "Halloween",         subtitle: "Trick-or-treat on October 31st",       emoji: "🎃", color: Color(red: 0.88, green: 0.52, blue: 0.12)),
    HolidayCard(name: "Thanksgiving",      subtitle: "A feast to give thanks",                emoji: "🦃", color: Color(red: 0.68, green: 0.42, blue: 0.22)),
    HolidayCard(name: "Hanukkah",          subtitle: "The Jewish festival of lights",         emoji: "🕎", color: Color(red: 0.22, green: 0.42, blue: 0.68)),
    HolidayCard(name: "Christmas",         subtitle: "Celebrate on December 25th",           emoji: "🎄", color: Color(red: 0.18, green: 0.58, blue: 0.42)),
]

struct HolidaysFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = holidayCards[index]
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
                ForEach(holidayCards.indices, id: \.self) { index in
                    HolidayCardView(card: holidayCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == holidayCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(holidayCards.count)")
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

struct HolidayCardView: View {
    let card: HolidayCard

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
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Text(card.subtitle)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
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
    HolidaysFlashcardsView()
}
