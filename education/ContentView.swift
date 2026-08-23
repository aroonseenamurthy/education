//
//  ContentView.swift
//  education
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.96, green: 0.97, blue: 1.0), Color(red: 0.86, green: 0.91, blue: 1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("✏️")
                            .font(.system(size: 60))
                        Text("Tiny Learn")
                            .font(.system(size: 46, weight: .black, design: .rounded))
                            .foregroundStyle(Color(red: 0.18, green: 0.22, blue: 0.55))
                        Text("Fun Learning for Kids!")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.45, green: 0.50, blue: 0.70))
                    }
                    .padding(.top, 64)

                    Spacer()

                    // Category cards
                    VStack(spacing: 22) {
                        NavigationLink(destination: AlphabetFlashcardsView()) {
                            CategoryCard(
                                title: "Alphabets",
                                subtitle: "A  to  Z",
                                emoji: "🔤",
                                colors: [Color(red: 0.92, green: 0.28, blue: 0.28),
                                         Color(red: 0.95, green: 0.52, blue: 0.28)]
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: NumberFlashcardsView()) {
                            CategoryCard(
                                title: "Numbers",
                                subtitle: "1  to  100",
                                emoji: "🔢",
                                colors: [Color(red: 0.22, green: 0.48, blue: 0.92),
                                         Color(red: 0.28, green: 0.72, blue: 0.88)]
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 28)

                    Spacer()

                    Text("Tap a card to start!")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.55, green: 0.58, blue: 0.72))
                        .padding(.bottom, 44)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CategoryCard: View {
    let title: String
    let subtitle: String
    let emoji: String
    let colors: [Color]

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.82))
            }
            Spacer()
            Text(emoji)
                .font(.system(size: 72))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 30)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: colors[0].opacity(0.35), radius: 14, x: 0, y: 6)
    }
}

#Preview {
    ContentView()
}
