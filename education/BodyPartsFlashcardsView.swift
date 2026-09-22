//
//  BodyPartsFlashcardsView.swift
//  education
//

import SwiftUI

struct BodyPartCard: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

private let bodyPartCards: [BodyPartCard] = [
    BodyPartCard(name: "Head",     emoji: "🧑",  color: Color(red: 0.88, green: 0.42, blue: 0.18)),
    BodyPartCard(name: "Eyes",     emoji: "👀",  color: Color(red: 0.22, green: 0.55, blue: 0.82)),
    BodyPartCard(name: "Ears",     emoji: "👂",  color: Color(red: 0.85, green: 0.45, blue: 0.62)),
    BodyPartCard(name: "Nose",     emoji: "👃",  color: Color(red: 0.92, green: 0.58, blue: 0.15)),
    BodyPartCard(name: "Mouth",    emoji: "👄",  color: Color(red: 0.88, green: 0.22, blue: 0.35)),
    BodyPartCard(name: "Hair",     emoji: "💇",  color: Color(red: 0.55, green: 0.32, blue: 0.68)),
    BodyPartCard(name: "Hands",    emoji: "🖐️", color: Color(red: 0.32, green: 0.62, blue: 0.42)),
    BodyPartCard(name: "Fingers",  emoji: "👆",  color: Color(red: 0.78, green: 0.52, blue: 0.15)),
    BodyPartCard(name: "Arms",     emoji: "💪",  color: Color(red: 0.22, green: 0.58, blue: 0.68)),
    BodyPartCard(name: "Legs",     emoji: "🦵",  color: Color(red: 0.68, green: 0.38, blue: 0.22)),
    BodyPartCard(name: "Feet",     emoji: "🦶",  color: Color(red: 0.42, green: 0.48, blue: 0.78)),
    BodyPartCard(name: "Shoulders",emoji: "🤷",  color: Color(red: 0.58, green: 0.42, blue: 0.72)),
    BodyPartCard(name: "Knees",    emoji: "🦵",  color: Color(red: 0.32, green: 0.68, blue: 0.55)),
    BodyPartCard(name: "Teeth",    emoji: "🦷",  color: Color(red: 0.62, green: 0.68, blue: 0.78)),
    BodyPartCard(name: "Tongue",   emoji: "👅",  color: Color(red: 0.88, green: 0.32, blue: 0.42)),
    BodyPartCard(name: "Heart",    emoji: "❤️", color: Color(red: 0.85, green: 0.15, blue: 0.22)),
    BodyPartCard(name: "Brain",    emoji: "🧠",  color: Color(red: 0.82, green: 0.52, blue: 0.62)),
    BodyPartCard(name: "Skin",     emoji: "🫱",  color: Color(red: 0.72, green: 0.55, blue: 0.42)),
]

struct BodyPartsFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        speech.speak(bodyPartCards[index].name)
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
                ForEach(bodyPartCards.indices, id: \.self) { index in
                    BodyPartCardView(card: bodyPartCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == bodyPartCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(bodyPartCards.count)")
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

struct BodyPartCardView: View {
    let card: BodyPartCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text(card.emoji)
                    .font(.system(size: 180))
                    .shadow(radius: 10)

                Text(card.name)
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    BodyPartsFlashcardsView()
}
