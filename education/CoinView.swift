//
//  CoinView.swift
//  education
//

import SwiftUI

struct CoinView: View {
    let diameter: CGFloat
    let baseColor: Color
    let ridged: Bool
    let valueText: String

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [baseColor.opacity(0.85), baseColor],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: diameter, height: diameter)
                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

            if ridged {
                ForEach(0..<40, id: \.self) { i in
                    Rectangle()
                        .fill(.black.opacity(0.30))
                        .frame(width: 2, height: 7)
                        .offset(y: -(diameter / 2 - 4))
                        .rotationEffect(.degrees(Double(i) * 9))
                }
            }

            Circle()
                .stroke(.black.opacity(0.25), lineWidth: 3)
                .frame(width: diameter - 16, height: diameter - 16)

            Image(systemName: "person.fill")
                .font(.system(size: diameter * 0.32))
                .foregroundStyle(.black.opacity(0.32))
                .offset(y: -diameter * 0.08)

            Text(valueText)
                .font(.system(size: diameter * 0.16, weight: .black, design: .rounded))
                .foregroundStyle(.black.opacity(0.45))
                .offset(y: diameter * 0.28)
        }
        .frame(width: diameter, height: diameter)
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(alignment: .bottom, spacing: 16) {
            CoinView(diameter: 160, baseColor: Color(red: 0.72, green: 0.45, blue: 0.28), ridged: false, valueText: "1¢")
            CoinView(diameter: 185, baseColor: Color(red: 0.70, green: 0.70, blue: 0.72), ridged: false, valueText: "5¢")
        }
        HStack(alignment: .bottom, spacing: 16) {
            CoinView(diameter: 140, baseColor: Color(red: 0.75, green: 0.76, blue: 0.78), ridged: true, valueText: "10¢")
            CoinView(diameter: 205, baseColor: Color(red: 0.68, green: 0.70, blue: 0.74), ridged: true, valueText: "25¢")
        }
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
