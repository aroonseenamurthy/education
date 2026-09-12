//
//  AnimalsFlashcardsView.swift
//  education
//

import SwiftUI

struct AnimalCard: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let sound: String
    let color: Color
}

private let animalCards: [AnimalCard] = [
    AnimalCard(name: "Dog",      emoji: "🐶", sound: "Woof",    color: Color(red: 0.88, green: 0.48, blue: 0.18)),
    AnimalCard(name: "Cat",      emoji: "🐱", sound: "Meow",    color: Color(red: 0.55, green: 0.28, blue: 0.78)),
    AnimalCard(name: "Cow",      emoji: "🐄", sound: "Moo",     color: Color(red: 0.18, green: 0.58, blue: 0.52)),
    AnimalCard(name: "Duck",     emoji: "🦆", sound: "Quack",   color: Color(red: 0.82, green: 0.62, blue: 0.08)),
    AnimalCard(name: "Lion",     emoji: "🦁", sound: "Roar",    color: Color(red: 0.90, green: 0.42, blue: 0.12)),
    AnimalCard(name: "Elephant", emoji: "🐘", sound: "Trumpet", color: Color(red: 0.42, green: 0.52, blue: 0.72)),
    AnimalCard(name: "Frog",     emoji: "🐸", sound: "Ribbit",  color: Color(red: 0.22, green: 0.68, blue: 0.32)),
    AnimalCard(name: "Pig",      emoji: "🐷", sound: "Oink",    color: Color(red: 0.92, green: 0.42, blue: 0.62)),
    AnimalCard(name: "Horse",    emoji: "🐴", sound: "Neigh",   color: Color(red: 0.65, green: 0.38, blue: 0.22)),
    AnimalCard(name: "Sheep",    emoji: "🐑", sound: "Baa",     color: Color(red: 0.32, green: 0.58, blue: 0.88)),
    AnimalCard(name: "Monkey",   emoji: "🐵", sound: "Ooh ooh", color: Color(red: 0.72, green: 0.45, blue: 0.22)),
    AnimalCard(name: "Owl",      emoji: "🦉", sound: "Hoot",    color: Color(red: 0.42, green: 0.28, blue: 0.62)),
    AnimalCard(name: "Bee",      emoji: "🐝", sound: "Buzz",    color: Color(red: 0.88, green: 0.70, blue: 0.08)),
    AnimalCard(name: "Bear",     emoji: "🐻", sound: "Growl",   color: Color(red: 0.55, green: 0.32, blue: 0.18)),
    AnimalCard(name: "Tiger",    emoji: "🐯", sound: "Roar",    color: Color(red: 0.88, green: 0.45, blue: 0.18)),
    AnimalCard(name: "Rabbit",   emoji: "🐰", sound: "Squeak",  color: Color(red: 0.72, green: 0.45, blue: 0.82)),
    AnimalCard(name: "Penguin",  emoji: "🐧", sound: "Squawk",  color: Color(red: 0.22, green: 0.38, blue: 0.72)),
    AnimalCard(name: "Snake",    emoji: "🐍", sound: "Hiss",    color: Color(red: 0.38, green: 0.62, blue: 0.28)),
    AnimalCard(name: "Bird",     emoji: "🐦", sound: "Tweet",   color: Color(red: 0.25, green: 0.62, blue: 0.88)),
    AnimalCard(name: "Fish",     emoji: "🐟", sound: "Blub",    color: Color(red: 0.18, green: 0.55, blue: 0.78)),
]

struct AnimalsFlashcardsView: View {
    @State private var currentIndex = 0
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = animalCards[index]
        speech.speakAnimalCard(name: card.name, sound: card.sound)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(animalCards.indices, id: \.self) { index in
                    AnimalCardView(card: animalCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in speakCard(newIndex) }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(animalCards.count)")
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

struct AnimalCardView: View {
    let card: AnimalCard

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
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

                Text(card.emoji)
                    .font(.system(size: 180))
                    .shadow(radius: 10)

                Text("says \(card.sound)!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.88))
                    .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    AnimalsFlashcardsView()
}
