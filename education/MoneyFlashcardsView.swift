//
//  MoneyFlashcardsView.swift
//  education
//

import SwiftUI

struct CoinCard: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let valueText: String
    let diameter: CGFloat
    let coinColor: Color
    let ridged: Bool
    let cardColor: Color
}

private let coinCards: [CoinCard] = [
    CoinCard(name: "Penny",   subtitle: "Worth 1 cent",   valueText: "1¢",  diameter: 160,
              coinColor: Color(red: 0.72, green: 0.45, blue: 0.28), ridged: false,
              cardColor: Color(red: 0.62, green: 0.38, blue: 0.22)),
    CoinCard(name: "Nickel",  subtitle: "Worth 5 cents",  valueText: "5¢",  diameter: 185,
              coinColor: Color(red: 0.70, green: 0.70, blue: 0.72), ridged: false,
              cardColor: Color(red: 0.32, green: 0.42, blue: 0.55)),
    CoinCard(name: "Dime",    subtitle: "Worth 10 cents — the smallest coin!", valueText: "10¢", diameter: 140,
              coinColor: Color(red: 0.75, green: 0.76, blue: 0.78), ridged: true,
              cardColor: Color(red: 0.42, green: 0.48, blue: 0.62)),
    CoinCard(name: "Quarter", subtitle: "Worth 25 cents — the biggest coin!",  valueText: "25¢", diameter: 205,
              coinColor: Color(red: 0.68, green: 0.70, blue: 0.74), ridged: true,
              cardColor: Color(red: 0.22, green: 0.55, blue: 0.52)),
]

struct MoneyFlashcardsView: View {
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        let card = coinCards[index]
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
                ForEach(coinCards.indices, id: \.self) { index in
                    CoinCardView(card: coinCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == coinCards.count - 1 { celebrate() }
            }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(coinCards.count)")
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

struct CoinCardView: View {
    let card: CoinCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.cardColor, card.cardColor.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                CoinView(diameter: card.diameter, baseColor: card.coinColor, ridged: card.ridged, valueText: card.valueText)
                    .frame(height: 210)

                Text(card.name)
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

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
    MoneyFlashcardsView()
}
