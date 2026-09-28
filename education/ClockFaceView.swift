//
//  ClockFaceView.swift
//  education
//

import SwiftUI

struct ClockFaceView: View {
    let hour: Int
    let minute: Int

    private var hourAngle: Double {
        let h = Double(hour % 12) + Double(minute) / 60.0
        return h * 30.0
    }

    private var minuteAngle: Double {
        Double(minute) * 6.0
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 210, height: 210)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)

            Circle()
                .stroke(Color(white: 0.15), lineWidth: 6)
                .frame(width: 210, height: 210)

            ForEach(0..<12, id: \.self) { i in
                Rectangle()
                    .fill(Color(white: 0.2))
                    .frame(width: i % 3 == 0 ? 5 : 3, height: i % 3 == 0 ? 18 : 10)
                    .offset(y: -90)
                    .rotationEffect(.degrees(Double(i) * 30))
            }

            // Hour hand
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(white: 0.15))
                .frame(width: 8, height: 56)
                .offset(y: -28)
                .rotationEffect(.degrees(hourAngle))

            // Minute hand
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.72, green: 0.22, blue: 0.22))
                .frame(width: 5, height: 82)
                .offset(y: -41)
                .rotationEffect(.degrees(minuteAngle))

            Circle()
                .fill(Color(white: 0.15))
                .frame(width: 14, height: 14)
        }
        .frame(width: 210, height: 210)
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 24) {
            ClockFaceView(hour: 3, minute: 0)
            ClockFaceView(hour: 6, minute: 0)
        }
        HStack(spacing: 24) {
            ClockFaceView(hour: 9, minute: 30)
            ClockFaceView(hour: 12, minute: 30)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
