//
//  ContentView.swift
//  education
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BasicsView()
                .tabItem {
                    Label("Basics", systemImage: "square.grid.2x2.fill")
                }
        }
    }
}

struct CategoryScreen<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

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
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                            content
                        }
                        .padding(.horizontal, 24)
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

struct BasicsView: View {
    var body: some View {
        CategoryScreen {
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

            NavigationLink(destination: FruitsVeggiesFlashcardsView()) {
                CategoryCard(
                    title: "Fruits & Veggies",
                    subtitle: "20 items",
                    emoji: "🍎",
                    colors: [Color(red: 0.18, green: 0.58, blue: 0.28),
                             Color(red: 0.38, green: 0.78, blue: 0.32)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: BodyPartsFlashcardsView()) {
                CategoryCard(
                    title: "Body Parts",
                    subtitle: "18 parts",
                    emoji: "🧑",
                    colors: [Color(red: 0.85, green: 0.42, blue: 0.55),
                             Color(red: 0.92, green: 0.60, blue: 0.62)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: SightWordsFlashcardsView()) {
                CategoryCard(
                    title: "Sight Words",
                    subtitle: "20 words",
                    emoji: "📖",
                    colors: [Color(red: 0.22, green: 0.42, blue: 0.78),
                             Color(red: 0.32, green: 0.62, blue: 0.85)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: CalendarFlashcardsView()) {
                CategoryCard(
                    title: "Days & Months",
                    subtitle: "Days, months, seasons",
                    emoji: "📅",
                    colors: [Color(red: 0.22, green: 0.55, blue: 0.82),
                             Color(red: 0.62, green: 0.32, blue: 0.72)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: HistoryFlashcardsView()) {
                CategoryCard(
                    title: "History Basics",
                    subtitle: "Famous people",
                    emoji: "🏛️",
                    colors: [Color(red: 0.62, green: 0.48, blue: 0.15),
                             Color(red: 0.42, green: 0.32, blue: 0.28)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: GeographyFlashcardsView()) {
                CategoryCard(
                    title: "Geography Basics",
                    subtitle: "24 countries & capitals",
                    emoji: "🌍",
                    colors: [Color(red: 0.18, green: 0.48, blue: 0.78),
                             Color(red: 0.22, green: 0.62, blue: 0.42)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: CivicsFlashcardsView()) {
                CategoryCard(
                    title: "Civics Basics",
                    subtitle: "Flag, voting, community",
                    emoji: "🗳️",
                    colors: [Color(red: 0.72, green: 0.22, blue: 0.28),
                             Color(red: 0.22, green: 0.42, blue: 0.68)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: SocialSkillsFlashcardsView()) {
                CategoryCard(
                    title: "Manners & Feelings",
                    subtitle: "Kindness & emotions",
                    emoji: "🤝",
                    colors: [Color(red: 0.22, green: 0.58, blue: 0.68),
                             Color(red: 0.72, green: 0.42, blue: 0.18)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: MathFlashcardsView()) {
                CategoryCard(
                    title: "Math Basics",
                    subtitle: "Add, subtract, multiply, divide",
                    emoji: "🧮",
                    colors: [Color(red: 0.18, green: 0.58, blue: 0.42),
                             Color(red: 0.42, green: 0.32, blue: 0.78)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: PhysicsFlashcardsView()) {
                CategoryCard(
                    title: "Physics Basics",
                    subtitle: "Push, pull, gravity & more",
                    emoji: "🧲",
                    colors: [Color(red: 0.22, green: 0.55, blue: 0.82),
                             Color(red: 0.42, green: 0.32, blue: 0.78)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: ChemistryFlashcardsView()) {
                CategoryCard(
                    title: "Chemistry Basics",
                    subtitle: "Solid, liquid, gas & more",
                    emoji: "🧪",
                    colors: [Color(red: 0.18, green: 0.62, blue: 0.78),
                             Color(red: 0.42, green: 0.68, blue: 0.32)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: BiologyFlashcardsView()) {
                CategoryCard(
                    title: "Biology Basics",
                    subtitle: "Living things & the five senses",
                    emoji: "🌱",
                    colors: [Color(red: 0.22, green: 0.62, blue: 0.32),
                             Color(red: 0.62, green: 0.32, blue: 0.72)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: TellingTimeFlashcardsView()) {
                CategoryCard(
                    title: "Telling Time",
                    subtitle: "Clocks & half hours",
                    emoji: "🕐",
                    colors: [Color(red: 0.22, green: 0.48, blue: 0.78),
                             Color(red: 0.62, green: 0.32, blue: 0.68)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: MoneyFlashcardsView()) {
                CategoryCard(
                    title: "Money Basics",
                    subtitle: "Penny, nickel, dime, quarter",
                    emoji: "🪙",
                    colors: [Color(red: 0.62, green: 0.38, blue: 0.22),
                             Color(red: 0.22, green: 0.55, blue: 0.52)]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: HolidaysFlashcardsView()) {
                CategoryCard(
                    title: "Holidays",
                    subtitle: "Celebrations all year long",
                    emoji: "🎉",
                    colors: [Color(red: 0.72, green: 0.22, blue: 0.28),
                             Color(red: 0.18, green: 0.58, blue: 0.42)]
                )
            }
            .buttonStyle(.plain)
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
        VStack(spacing: 10) {
            Text(emoji)
                .font(.system(size: 46))

            Text(title)
                .font(.system(size: 19, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(subtitle)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.82))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, minHeight: 160)
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: colors[0].opacity(0.35), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ContentView()
}
