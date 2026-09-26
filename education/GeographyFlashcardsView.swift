//
//  GeographyFlashcardsView.swift
//  education
//

import SwiftUI

struct GeographyCard: Identifiable {
    let id = UUID()
    let country: String
    let capital: String
    let flag: String
    let symbol: String
    let color: Color
}

private let americas = "globe.americas.fill"
private let europeAfrica = "globe.europe.africa.fill"
private let asiaAustralia = "globe.asia.australia.fill"

private let geographyCards: [GeographyCard] = [
    GeographyCard(country: "United States",  capital: "Washington, D.C.", flag: "🇺🇸", symbol: americas,      color: Color(red: 0.22, green: 0.42, blue: 0.68)),
    GeographyCard(country: "Canada",         capital: "Ottawa",           flag: "🇨🇦", symbol: americas,      color: Color(red: 0.72, green: 0.22, blue: 0.28)),
    GeographyCard(country: "Mexico",         capital: "Mexico City",      flag: "🇲🇽", symbol: americas,      color: Color(red: 0.22, green: 0.58, blue: 0.32)),
    GeographyCard(country: "Brazil",         capital: "Brasília",         flag: "🇧🇷", symbol: americas,      color: Color(red: 0.18, green: 0.62, blue: 0.42)),
    GeographyCard(country: "Argentina",      capital: "Buenos Aires",     flag: "🇦🇷", symbol: americas,      color: Color(red: 0.42, green: 0.58, blue: 0.82)),
    GeographyCard(country: "United Kingdom", capital: "London",           flag: "🇬🇧", symbol: europeAfrica,  color: Color(red: 0.22, green: 0.32, blue: 0.68)),
    GeographyCard(country: "France",         capital: "Paris",            flag: "🇫🇷", symbol: europeAfrica,  color: Color(red: 0.28, green: 0.42, blue: 0.78)),
    GeographyCard(country: "Germany",        capital: "Berlin",           flag: "🇩🇪", symbol: europeAfrica,  color: Color(red: 0.42, green: 0.32, blue: 0.28)),
    GeographyCard(country: "Italy",          capital: "Rome",             flag: "🇮🇹", symbol: europeAfrica,  color: Color(red: 0.22, green: 0.58, blue: 0.42)),
    GeographyCard(country: "Spain",          capital: "Madrid",           flag: "🇪🇸", symbol: europeAfrica,  color: Color(red: 0.82, green: 0.52, blue: 0.15)),
    GeographyCard(country: "Russia",         capital: "Moscow",           flag: "🇷🇺", symbol: europeAfrica,  color: Color(red: 0.52, green: 0.32, blue: 0.32)),
    GeographyCard(country: "Egypt",          capital: "Cairo",            flag: "🇪🇬", symbol: europeAfrica,  color: Color(red: 0.72, green: 0.58, blue: 0.18)),
    GeographyCard(country: "South Africa",   capital: "Pretoria",         flag: "🇿🇦", symbol: europeAfrica,  color: Color(red: 0.42, green: 0.68, blue: 0.32)),
    GeographyCard(country: "Nigeria",        capital: "Abuja",            flag: "🇳🇬", symbol: europeAfrica,  color: Color(red: 0.22, green: 0.62, blue: 0.28)),
    GeographyCard(country: "Kenya",          capital: "Nairobi",          flag: "🇰🇪", symbol: europeAfrica,  color: Color(red: 0.62, green: 0.32, blue: 0.18)),
    GeographyCard(country: "China",          capital: "Beijing",          flag: "🇨🇳", symbol: asiaAustralia, color: Color(red: 0.82, green: 0.22, blue: 0.22)),
    GeographyCard(country: "Japan",          capital: "Tokyo",            flag: "🇯🇵", symbol: asiaAustralia, color: Color(red: 0.78, green: 0.28, blue: 0.32)),
    GeographyCard(country: "India",          capital: "New Delhi",        flag: "🇮🇳", symbol: asiaAustralia, color: Color(red: 0.62, green: 0.42, blue: 0.18)),
    GeographyCard(country: "South Korea",    capital: "Seoul",            flag: "🇰🇷", symbol: asiaAustralia, color: Color(red: 0.28, green: 0.48, blue: 0.72)),
    GeographyCard(country: "Australia",      capital: "Canberra",         flag: "🇦🇺", symbol: asiaAustralia, color: Color(red: 0.18, green: 0.52, blue: 0.62)),
    GeographyCard(country: "Thailand",       capital: "Bangkok",          flag: "🇹🇭", symbol: asiaAustralia, color: Color(red: 0.62, green: 0.22, blue: 0.32)),
    GeographyCard(country: "Indonesia",      capital: "Jakarta",          flag: "🇮🇩", symbol: asiaAustralia, color: Color(red: 0.72, green: 0.28, blue: 0.22)),
    GeographyCard(country: "Turkey",         capital: "Ankara",           flag: "🇹🇷", symbol: europeAfrica,  color: Color(red: 0.72, green: 0.22, blue: 0.28)),
    GeographyCard(country: "Greece",         capital: "Athens",           flag: "🇬🇷", symbol: europeAfrica,  color: Color(red: 0.22, green: 0.48, blue: 0.72)),
]

struct GeographyFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = geographyCards[index]
        speech.speak("\(card.country). The capital is \(card.capital).")
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
                ForEach(geographyCards.indices, id: \.self) { index in
                    GeographyCardView(card: geographyCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == geographyCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(geographyCards.count)")
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

struct GeographyCardView: View {
    let card: GeographyCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.color, card.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Image(systemName: card.symbol)
                .font(.system(size: 320))
                .foregroundStyle(.white.opacity(0.14))
                .rotationEffect(.degrees(-10))
                .offset(x: 30, y: -30)
                .allowsHitTesting(false)

            VStack(spacing: 20) {
                Text(card.flag)
                    .font(.system(size: 150))
                    .shadow(radius: 10)

                Text(card.country)
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Text("Capital: \(card.capital)")
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
    GeographyFlashcardsView()
}
