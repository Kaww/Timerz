//
//  CircularTimerView.swift
//  Timerz
//
//  Created by KAWRANTIN LE GOFF on 31/01/2021.
//

import SwiftUI

struct CircularTimerView: View {
    var selectedTime: Double?
    @Binding var time: Double
    @Binding var isTimerRunning: Bool
    @Binding var isTimerPaused: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.black.opacity(0.1),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
            
            ProgressBarView(
                selectedTime: selectedTime,
                time: $time
            )
            
            VStack(spacing: 0) {
                Text("\(time, specifier: "%.0f")")
                    .font(.system(size: 150, weight: .bold, design: .rounded))
                Text("Seconds")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            .opacity(0.9)
        }
        .frame(width: screenSize.width * 0.8, height: screenSize.width * 0.8)
    }
    
    private func date(from time: Double) -> Date {
        if Int(time) <= 0 {
            return Date()
        }
        return Calendar.current.date(byAdding: .second, value: Int(time), to: Date()) ?? Date()
    }
}

struct ProgressBarView: View {
    var selectedTime: Double?
    @Binding var time: Double
    
    var body: some View {
        Circle()
            .trim(from: 0, to: percent(of: time, in: selectedTime))
            .stroke(
                color(from: percent(of: time, in: selectedTime)),
                style: StrokeStyle(
                    lineWidth: 20,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut(duration: 0.8))
            .glow()
    }
    
    private func percent(of time: Double, in selectedTime: Double?) -> CGFloat {
        guard let selectedTime = selectedTime else { return 1 }
        return CGFloat(1 - (selectedTime - time) / selectedTime)
    }
    
    private func color(from percent: CGFloat) -> Color {
        if percent <= 0.1 {
            return Color.red
        } else if percent <= 0.2 {
            return Color.orange
        } else if percent <= 0.4 {
            return  Color.yellow
        }
        return Color.green
    }
}

struct GlowModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: 15)
            content
        }
    }
}

extension View {
    func glow() -> some View {
        self.modifier(GlowModifier())
    }
}
