//
//  MathFlashcardsView.swift
//  education
//

import SwiftUI

enum MathOperation: String, CaseIterable, Identifiable {
    case addition = "Addition"
    case subtraction = "Subtraction"
    case multiplication = "Multiplication"
    case division = "Division"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }

    var spokenWord: String {
        switch self {
        case .addition: return "plus"
        case .subtraction: return "minus"
        case .multiplication: return "times"
        case .division: return "divided by"
        }
    }

    var emoji: String {
        switch self {
        case .addition: return "➕"
        case .subtraction: return "➖"
        case .multiplication: return "✖️"
        case .division: return "➗"
        }
    }

    var color: Color {
        switch self {
        case .addition: return Color(red: 0.18, green: 0.58, blue: 0.42)
        case .subtraction: return Color(red: 0.82, green: 0.42, blue: 0.18)
        case .multiplication: return Color(red: 0.42, green: 0.32, blue: 0.78)
        case .division: return Color(red: 0.15, green: 0.48, blue: 0.72)
        }
    }
}

struct MathCard: Identifiable {
    let id = UUID()
    let left: Int
    let right: Int
    let operation: MathOperation

    var answer: Int {
        switch operation {
        case .addition: return left + right
        case .subtraction: return left - right
        case .multiplication: return left * right
        case .division: return left / right
        }
    }

    var equationText: String { "\(left) \(operation.symbol) \(right) = \(answer)" }

    var speechText: String { "\(left) \(operation.spokenWord) \(right) equals \(answer)" }
}

private func makeCards(_ operation: MathOperation, _ pairs: [(Int, Int)]) -> [MathCard] {
    pairs.map { MathCard(left: $0.0, right: $0.1, operation: operation) }
}

private let additionCards = makeCards(.addition, [
    (1, 1), (2, 1), (1, 2), (2, 2), (3, 1), (1, 3), (3, 2), (2, 3), (4, 1), (1, 4),
    (4, 2), (2, 4), (3, 3), (5, 1), (1, 5), (5, 2), (4, 3), (5, 3), (4, 4), (5, 4),
    (4, 5), (5, 5), (6, 4), (7, 3),
])

private let subtractionCards = makeCards(.subtraction, [
    (2, 1), (3, 1), (3, 2), (4, 1), (4, 2), (4, 3), (5, 1), (5, 2), (5, 3), (5, 4),
    (6, 2), (6, 3), (6, 4), (7, 3), (7, 4), (8, 3), (8, 4), (9, 4), (9, 5), (10, 5),
    (10, 6), (10, 4),
])

private let multiplicationCards = makeCards(.multiplication, [
    (1, 1), (2, 1), (1, 2), (2, 2), (3, 1), (1, 3), (2, 3), (3, 2), (3, 3), (4, 1),
    (1, 4), (4, 2), (2, 4), (5, 1), (1, 5), (5, 2), (2, 5), (3, 4), (4, 3), (5, 3),
    (3, 5),
])

private let divisionCards = makeCards(.division, [
    (2, 1), (2, 2), (3, 1), (3, 3), (4, 1), (4, 2), (4, 4), (6, 1), (6, 2), (6, 3),
    (8, 2), (8, 4), (9, 1), (9, 3), (10, 2), (10, 5), (12, 3), (12, 4), (15, 3),
    (15, 5), (20, 4), (20, 5),
])

struct MathFlashcardsView: View {
    @State private var selectedOperation: MathOperation = .addition
    @State private var currentIndex = 0
    @State private var showCelebration = false
    @StateObject private var speech = SpeechManager()
    @Environment(\.dismiss) private var dismiss

    private var cards: [MathCard] {
        switch selectedOperation {
        case .addition: return additionCards
        case .subtraction: return subtractionCards
        case .multiplication: return multiplicationCards
        case .division: return divisionCards
        }
    }

    private func speakCard(_ index: Int) {
        guard cards.indices.contains(index) else { return }
        speech.speak(cards[index].speechText)
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
                ForEach(cards.indices, id: \.self) { index in
                    MathCardView(card: cards[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear { speakCard(0) }
            .onChange(of: currentIndex) { _, newIndex in
                speakCard(newIndex)
                if newIndex == cards.count - 1 { celebrate() }
            }
            .onChange(of: selectedOperation) { _, _ in
                currentIndex = 0
                speakCard(0)
            }

            VStack(spacing: 14) {
                Picker("Operation", selection: $selectedOperation) {
                    ForEach(MathOperation.allCases) { op in
                        Text("\(op.emoji) \(op.rawValue)").tag(op)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)

                HStack {
                    Spacer()
                    Text("\(currentIndex + 1)  of  \(cards.count)")
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
            }
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

struct MathCardView: View {
    let card: MathCard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [card.operation.color, card.operation.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Text(card.equationText)
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                MathVisualView(card: card)
                    .frame(maxHeight: 280)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 70)
        }
    }
}

struct MathVisualView: View {
    let card: MathCard

    private var answerRow: some View {
        HStack(spacing: 16) {
            Text("=")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
            DotGroup(count: card.answer, color: Color(red: 1.0, green: 0.85, blue: 0.2))
        }
    }

    var body: some View {
        switch card.operation {
        case .addition:
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    DotGroup(count: card.left, color: .white)
                    Text("+")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.white.opacity(0.75))
                    DotGroup(count: card.right, color: .white.opacity(0.55))
                }
                answerRow
            }
        case .subtraction:
            VStack(spacing: 16) {
                CrossOutDotGroup(total: card.left, removed: card.right)
                answerRow
            }
        case .multiplication:
            VStack(spacing: 16) {
                MultiplicationGrid(rows: card.left, columns: card.right)
                answerRow
            }
        case .division:
            VStack(spacing: 16) {
                DivisionGroups(total: card.left, groups: card.right)
                answerRow
            }
        }
    }
}

struct DotGroup: View {
    let count: Int
    let color: Color
    private let perRow = 5

    private var dotSize: CGFloat {
        switch count {
        case ...9: return 26
        case ...16: return 20
        default: return 15
        }
    }

    var body: some View {
        let rows = max(1, (count + perRow - 1) / perRow)
        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { row in
                let start = row * perRow
                let end = min(start + perRow, count)
                HStack(spacing: 8) {
                    ForEach(start..<end, id: \.self) { _ in
                        Circle().fill(color).frame(width: dotSize, height: dotSize)
                    }
                }
            }
        }
    }
}

struct CrossOutDotGroup: View {
    let total: Int
    let removed: Int
    private let perRow = 5

    var body: some View {
        let rows = max(1, (total + perRow - 1) / perRow)
        let keepCount = total - removed
        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { row in
                let start = row * perRow
                let end = min(start + perRow, total)
                HStack(spacing: 8) {
                    ForEach(start..<end, id: \.self) { i in
                        ZStack {
                            Circle().fill(.white).frame(width: 28, height: 28)
                            if i >= keepCount {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MultiplicationGrid: View {
    let rows: Int
    let columns: Int

    private var dotSize: CGFloat {
        switch rows * columns {
        case ...9: return 30
        case ...16: return 24
        default: return 18
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<rows, id: \.self) { _ in
                HStack(spacing: 6) {
                    ForEach(0..<columns, id: \.self) { _ in
                        Circle().fill(.white).frame(width: dotSize, height: dotSize)
                    }
                }
            }
        }
    }
}

struct DivisionGroups: View {
    let total: Int
    let groups: Int

    private var perGroup: Int { groups == 0 ? 0 : total / groups }

    private var dotSize: CGFloat {
        switch total {
        case ...9: return 20
        case ...16: return 16
        default: return 13
        }
    }

    var body: some View {
        let columns = min(groups, 5)
        let rows = max(1, (groups + columns - 1) / columns)
        let dotsPerRow = min(perGroup, 3)
        let dotRows = max(1, (perGroup + dotsPerRow - 1) / dotsPerRow)

        VStack(spacing: 10) {
            ForEach(0..<rows, id: \.self) { row in
                let start = row * columns
                let end = min(start + columns, groups)
                HStack(spacing: 10) {
                    ForEach(start..<end, id: \.self) { _ in
                        VStack(spacing: 4) {
                            ForEach(0..<dotRows, id: \.self) { dr in
                                let s = dr * dotsPerRow
                                let e = min(s + dotsPerRow, perGroup)
                                HStack(spacing: 4) {
                                    ForEach(s..<e, id: \.self) { _ in
                                        Circle().fill(.white).frame(width: dotSize, height: dotSize)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.15)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.5), lineWidth: 1.5))
                    }
                }
            }
        }
    }
}

#Preview {
    MathFlashcardsView()
}
