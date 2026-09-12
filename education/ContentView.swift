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
                    VStack(spacing: 6) {
                        AppLogoView()
                        Text("Tiny Learn")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(Color(red: 0.18, green: 0.22, blue: 0.55))
                        Text("Fun Learning for Kids!")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.45, green: 0.50, blue: 0.70))
                    }
                    .padding(.top, 56)
                    .padding(.bottom, 20)

                    // Scrollable category cards
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
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

                            NavigationLink(destination: ColorsFlashcardsView()) {
                                CategoryCard(
                                    title: "Colors",
                                    subtitle: "12 colors",
                                    emoji: "🎨",
                                    colors: [Color(red: 0.55, green: 0.18, blue: 0.78),
                                             Color(red: 0.92, green: 0.38, blue: 0.62)]
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: ShapesFlashcardsView()) {
                                CategoryCard(
                                    title: "Shapes",
                                    subtitle: "11 shapes",
                                    emoji: "🔷",
                                    colors: [Color(red: 0.12, green: 0.58, blue: 0.42),
                                             Color(red: 0.18, green: 0.75, blue: 0.55)]
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: AnimalsFlashcardsView()) {
                                CategoryCard(
                                    title: "Animals",
                                    subtitle: "20 animals",
                                    emoji: "🐾",
                                    colors: [Color(red: 0.78, green: 0.42, blue: 0.12),
                                             Color(red: 0.92, green: 0.65, blue: 0.18)]
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 24)
                    }

                    Text("Tap a card to start!")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.55, green: 0.58, blue: 0.72))
                        .padding(.bottom, 36)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AppLogoView: View {
    var body: some View {
        Text("🎒")
            .font(.system(size: 72))
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
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.82))
            }
            Spacer()
            Text(emoji)
                .font(.system(size: 64))
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 24)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: colors[0].opacity(0.35), radius: 12, x: 0, y: 5)
    }
}

#Preview {
    ContentView()
}
