//
//  FruitsVeggiesFlashcardsView.swift
//  education
//

import SwiftUI

struct FruitsVeggiesCard: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let category: String
    let color: Color
}

private let fruitsVeggiesCards: [FruitsVeggiesCard] = [
    FruitsVeggiesCard(name: "Apple",      emoji: "🍎", category: "Fruit",     color: Color(red: 0.88, green: 0.18, blue: 0.18)),
    FruitsVeggiesCard(name: "Banana",     emoji: "🍌", category: "Fruit",     color: Color(red: 0.88, green: 0.72, blue: 0.08)),
    FruitsVeggiesCard(name: "Orange",     emoji: "🍊", category: "Fruit",     color: Color(red: 0.92, green: 0.50, blue: 0.12)),
    FruitsVeggiesCard(name: "Strawberry", emoji: "🍓", category: "Fruit",     color: Color(red: 0.88, green: 0.22, blue: 0.35)),
    FruitsVeggiesCard(name: "Grapes",     emoji: "🍇", category: "Fruit",     color: Color(red: 0.52, green: 0.22, blue: 0.78)),
    FruitsVeggiesCard(name: "Watermelon", emoji: "🍉", category: "Fruit",     color: Color(red: 0.22, green: 0.68, blue: 0.35)),
    FruitsVeggiesCard(name: "Pineapple",  emoji: "🍍", category: "Fruit",     color: Color(red: 0.82, green: 0.58, blue: 0.08)),
    FruitsVeggiesCard(name: "Mango",      emoji: "🥭", category: "Fruit",     color: Color(red: 0.92, green: 0.55, blue: 0.15)),
    FruitsVeggiesCard(name: "Peach",      emoji: "🍑", category: "Fruit",     color: Color(red: 0.95, green: 0.52, blue: 0.38)),
    FruitsVeggiesCard(name: "Cherry",     emoji: "🍒", category: "Fruit",     color: Color(red: 0.78, green: 0.12, blue: 0.25)),
    FruitsVeggiesCard(name: "Lemon",      emoji: "🍋", category: "Fruit",     color: Color(red: 0.85, green: 0.78, blue: 0.08)),
    FruitsVeggiesCard(name: "Pear",       emoji: "🍐", category: "Fruit",     color: Color(red: 0.52, green: 0.72, blue: 0.22)),
    FruitsVeggiesCard(name: "Carrot",     emoji: "🥕", category: "Vegetable", color: Color(red: 0.92, green: 0.48, blue: 0.12)),
    FruitsVeggiesCard(name: "Broccoli",   emoji: "🥦", category: "Vegetable", color: Color(red: 0.18, green: 0.58, blue: 0.28)),
    FruitsVeggiesCard(name: "Corn",       emoji: "🌽", category: "Vegetable", color: Color(red: 0.88, green: 0.72, blue: 0.15)),
    FruitsVeggiesCard(name: "Tomato",     emoji: "🍅", category: "Vegetable", color: Color(red: 0.85, green: 0.22, blue: 0.22)),
    FruitsVeggiesCard(name: "Potato",     emoji: "🥔", category: "Vegetable", color: Color(red: 0.65, green: 0.48, blue: 0.28)),
    FruitsVeggiesCard(name: "Eggplant",   emoji: "🍆", category: "Vegetable", color: Color(red: 0.45, green: 0.18, blue: 0.58)),
    FruitsVeggiesCard(name: "Cucumber",   emoji: "🥒", category: "Vegetable", color: Color(red: 0.25, green: 0.62, blue: 0.32)),
    FruitsVeggiesCard(name: "Pepper",     emoji: "🫑", category: "Vegetable", color: Color(red: 0.28, green: 0.65, blue: 0.28)),
]

struct FruitsVeggiesFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        speech.speak(fruitsVeggiesCards[index].name)
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
                ForEach(fruitsVeggiesCards.indices, id: \.self) { index in
                    FruitsVeggiesCardView(card: fruitsVeggiesCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == fruitsVeggiesCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(fruitsVeggiesCards.count)")
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

struct FruitsVeggiesCardView: View {
    let card: FruitsVeggiesCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(card.name)
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

                Text(card.emoji)
                    .font(.system(size: 180))
                    .shadow(radius: 10)

                Text(card.category)
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
    FruitsVeggiesFlashcardsView()
}
