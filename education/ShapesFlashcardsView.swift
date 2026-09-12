//
//  ShapesFlashcardsView.swift
//  education
//

import SwiftUI

// MARK: - Custom shape paths

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to:    CGPoint(x: rect.midX,  y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX,  y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX,  y: rect.maxY))
            p.closeSubpath()
        }
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to:    CGPoint(x: rect.midX,  y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX,  y: rect.midY))
            p.addLine(to: CGPoint(x: rect.midX,  y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX,  y: rect.midY))
            p.closeSubpath()
        }
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer  = min(rect.width, rect.height) / 2
        let inner  = outer * 0.42
        let start  = -CGFloat.pi / 2
        var path   = Path()
        for i in 0..<10 {
            let r = i.isMultiple(of: 2) ? outer : inner
            let a = start + CGFloat(i) * .pi / 5
            let pt = CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        return Path { p in
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.85))
            p.addCurve(to: CGPoint(x: 0,       y: h * 0.30),
                       control1: CGPoint(x: w * 0.10, y: h * 0.65),
                       control2: CGPoint(x: 0,        y: h * 0.50))
            p.addArc(center: CGPoint(x: w * 0.25, y: h * 0.27), radius: w * 0.25,
                     startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            p.addArc(center: CGPoint(x: w * 0.75, y: h * 0.27), radius: w * 0.25,
                     startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            p.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.85),
                       control1: CGPoint(x: w,        y: h * 0.50),
                       control2: CGPoint(x: w * 0.90, y: h * 0.65))
        }
    }
}

struct PolygonShape: Shape {
    let sides: Int
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start  = -CGFloat.pi / 2
        var path   = Path()
        for i in 0..<sides {
            let a  = start + CGFloat(i) * 2 * .pi / CGFloat(sides)
            let pt = CGPoint(x: center.x + radius * cos(a), y: center.y + radius * sin(a))
            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Data

struct ShapeCard: Identifiable {
    let id = UUID()
    let name: String
    let kind: String          // used to pick the drawn shape
    let emoji: String         // real-world example
    let background: [Color]
}

private let shapeCards: [ShapeCard] = [
    ShapeCard(name: "Circle",    kind: "circle",    emoji: "⚽️",
              background: [Color(red: 0.88, green: 0.20, blue: 0.20), Color(red: 0.68, green: 0.10, blue: 0.10)]),
    ShapeCard(name: "Square",    kind: "square",    emoji: "🎲",
              background: [Color(red: 0.20, green: 0.45, blue: 0.90), Color(red: 0.12, green: 0.28, blue: 0.72)]),
    ShapeCard(name: "Triangle",  kind: "triangle",  emoji: "🍕",
              background: [Color(red: 0.18, green: 0.65, blue: 0.30), Color(red: 0.10, green: 0.48, blue: 0.20)]),
    ShapeCard(name: "Rectangle", kind: "rectangle", emoji: "📱",
              background: [Color(red: 0.90, green: 0.52, blue: 0.12), Color(red: 0.72, green: 0.35, blue: 0.05)]),
    ShapeCard(name: "Star",      kind: "star",      emoji: "🌟",
              background: [Color(red: 0.88, green: 0.68, blue: 0.05), Color(red: 0.72, green: 0.52, blue: 0.02)]),
    ShapeCard(name: "Heart",     kind: "heart",     emoji: "🌹",
              background: [Color(red: 0.90, green: 0.25, blue: 0.52), Color(red: 0.72, green: 0.15, blue: 0.38)]),
    ShapeCard(name: "Diamond",   kind: "diamond",   emoji: "💎",
              background: [Color(red: 0.12, green: 0.60, blue: 0.80), Color(red: 0.08, green: 0.42, blue: 0.65)]),
    ShapeCard(name: "Oval",      kind: "oval",      emoji: "🥚",
              background: [Color(red: 0.52, green: 0.20, blue: 0.78), Color(red: 0.38, green: 0.12, blue: 0.60)]),
    ShapeCard(name: "Pentagon",  kind: "pentagon",  emoji: "🏠",
              background: [Color(red: 0.60, green: 0.35, blue: 0.18), Color(red: 0.42, green: 0.22, blue: 0.08)]),
    ShapeCard(name: "Hexagon",   kind: "hexagon",   emoji: "🍯",
              background: [Color(red: 0.92, green: 0.40, blue: 0.62), Color(red: 0.75, green: 0.25, blue: 0.48)]),
    ShapeCard(name: "Octagon",   kind: "octagon",   emoji: "🛑",
              background: [Color(red: 0.30, green: 0.30, blue: 0.38), Color(red: 0.18, green: 0.18, blue: 0.25)]),
]

// MARK: - Drawn shape switcher

struct DrawnShape: View {
    let kind: String

    var body: some View {
        Group {
            switch kind {
            case "circle":
                Circle().fill(.white)
            case "square":
                Rectangle().fill(.white).aspectRatio(1, contentMode: .fit)
            case "triangle":
                TriangleShape().fill(.white)
            case "rectangle":
                Rectangle().fill(.white).aspectRatio(2.0, contentMode: .fit)
            case "star":
                StarShape().fill(.white)
            case "heart":
                HeartShape().fill(.white)
            case "diamond":
                DiamondShape().fill(.white)
            case "oval":
                Ellipse().fill(.white)
            case "pentagon":
                PolygonShape(sides: 5).fill(.white)
            case "hexagon":
                PolygonShape(sides: 6).fill(.white)
            case "octagon":
                PolygonShape(sides: 8).fill(.white)
            default:
                Circle().fill(.white)
            }
        }
        .shadow(color: .black.opacity(0.20), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Views

struct ShapesFlashcardsView: View {
    @State private var currentIndex = 0
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private func speakCard(_ index: Int) {
        speech.speak(shapeCards[index].name)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(shapeCards.indices, id: \.self) { index in
                    ShapeCardView(card: shapeCards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in speakCard(newIndex) }

            HStack {
                Spacer()
                Text("\(currentIndex + 1)  of  \(shapeCards.count)")
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

struct ShapeCardView: View {
    let card: ShapeCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: card.background,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text(card.name)
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

                DrawnShape(kind: card.kind)
                    .frame(width: 200, height: 200)

                Text(card.emoji)
                    .font(.system(size: 80))
                    .shadow(radius: 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    ShapesFlashcardsView()
}
