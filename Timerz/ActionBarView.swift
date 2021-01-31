//
//  ActionBarView.swift
//  Timerz
//
//  Created by KAWRANTIN LE GOFF on 31/01/2021.
//

import SwiftUI

struct ActionBarView: View {
    @Binding var selectedTime: Double?
    @Binding var time: Double
    @Binding var steps: Double
    @Binding var isTimerRunning: Bool
    @Binding var isTimerPaused: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            ReduceButtonView(
                selectedTime: $selectedTime,
                time: $time,
                steps: $steps,
                isTimerRunning: $isTimerRunning
            )
            
            PlayPauseButtonView(
                selectedTime: $selectedTime,
                time: $time,
                isTimerRunning: $isTimerRunning,
                isTimerPaused: $isTimerPaused
            )
            
            IncreaseButtonView(
                selectedTime: $selectedTime,
                time: $time,
                steps: $steps
            )
        }
    }
}

struct ReduceButtonView: View {
    @Binding var selectedTime: Double?
    @Binding var time: Double
    @Binding var steps: Double
    @Binding var isTimerRunning: Bool
    
    var body: some View {
        Button(action: {
            guard time > 0 else { return }
            if time > steps {
                time -= steps
            } else {
                time = 0
            }
            selectedTime = time
        }, label: {
            HStack {
                Image(systemName: "chevron.backward.2")
                Text("-10")
            }
            .actionButtonStyle(color: .blue, style: .filled)
        })
        .disabled(time <= 0 || isTimerRunning)
        .opacity(time <= 0 || isTimerRunning ? 0.6 : 1)
    }
}

struct IncreaseButtonView: View {
    @Binding var selectedTime: Double?
    @Binding var time: Double
    @Binding var steps: Double
    
    var body: some View {
        Button(action: {
            guard time < 60 else { return }
            if time < 60 - steps {
                time += steps
                selectedTime = (selectedTime ?? 0) + steps
            } else {
                selectedTime = (selectedTime ?? 0) + (60 - time)
                time = 60
            }
        }, label: {
            HStack {
                Text("+10")
                Image(systemName: "chevron.forward.2")
            }
            .actionButtonStyle(color: .blue, style: .filled)
        })
        .disabled(time >= 60)
        .opacity(time >= 60 ? 0.6 : 1)
    }
}

struct PlayPauseButtonView: View {
    @Binding var selectedTime: Double?
    @Binding var time: Double
    @Binding var isTimerRunning: Bool
    @Binding var isTimerPaused: Bool
    
    var body: some View {
        Button(action: {
            if isTimerPaused {
                startTimer()
            } else {
                pauseTimer()
            }
        }, label: {
            Image(systemName: isTimerPaused ? "play.circle.fill" : "pause.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .scaleEffect(0.8)
                )
        })
        .disabled(time <= 0)
        .opacity(time <= 0 ? 0.6 : 1)
    }
    
    private func startTimer() {
        vibrateSuccess()
        
        if !isTimerRunning {
            selectedTime = time
            isTimerRunning = true
        }
        isTimerPaused = false
    }
    
    private func pauseTimer() {
        vibrateSuccess()
        isTimerPaused = true
    }
    
    private func vibrateSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
