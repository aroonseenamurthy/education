//
//  NumberFlashcardsView.swift
//  education
//

import SwiftUI

private func numberToWord(_ n: Int) -> String {
    let ones = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
                "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen",
                "Seventeen", "Eighteen", "Nineteen"]
    let tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
    if n == 100 { return "One Hundred" }
    if n < 20 { return ones[n] }
    let t = tens[n / 10]
    let o = ones[n % 10]
    return o.isEmpty ? t : "\(t)-\(o)"
}

private let numberColors: [Color] = [
    Color(red: 0.92, green: 0.28, blue: 0.28),
    Color(red: 0.28, green: 0.50, blue: 0.92),
    Color(red: 0.92, green: 0.58, blue: 0.18),
    Color(red: 0.30, green: 0.72, blue: 0.40),
    Color(red: 0.55, green: 0.38, blue: 0.82),
    Color(red: 0.20, green: 0.62, blue: 0.85),
    Color(red: 0.52, green: 0.28, blue: 0.72),
    Color(red: 0.78, green: 0.48, blue: 0.22),
    Color(red: 0.92, green: 0.42, blue: 0.62),
    Color(red: 0.32, green: 0.62, blue: 0.78),
]

struct StarGridView: View {
    let count: Int

    private var starsPerRow: Int {
        switch count {
        case 1...5:  return count
        case 6...10: return 5
        default:     return 10
        }
    }

    private var starSize: CGFloat {
        switch count {
        case 1...5:   return 52
        case 6...10:  return 44
        case 11...20: return 36
        case 21...50: return 26
        default:      return 20
        }
    }

    var body: some View {
        let perRow = starsPerRow
        let size   = starSize
        let gap    = size * 0.18
        let rows   = (count + perRow - 1) / perRow

        VStack(spacing: gap) {
            ForEach(0..<rows, id: \.self) { row in
                let start = row * perRow
                let end   = min(start + perRow, count)
                HStack(spacing: gap) {
                    ForEach(start..<end, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: size))
                            .foregroundStyle(Color(red: 1.0, green: 0.88, blue: 0.15))
                            .shadow(color: .white.opacity(0.55), radius: 3)
                    }
                }
            }
        }
    }
}

struct NumberFlashcardsView: View {
    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(0..<100, id: \.self) { index in
                    NumberCardView(number: index + 1)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            Text("\(currentIndex + 1)  of  100")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
                .padding(.bottom, 36)
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
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

struct NumberCardView: View {
    let number: Int

    private var color: Color { numberColors[(number - 1) % numberColors.count] }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [color, color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("\(number)")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

                StarGridView(count: number)
                    .frame(maxHeight: 280)
                    .clipped()
                    .padding(.vertical, 8)

                Text(numberToWord(number))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    NumberFlashcardsView()
}
