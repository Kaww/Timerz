//
//  ContentView.swift
//  Timerz
//
//  Created by KAWRANTIN LE GOFF on 31/01/2021.
//

import SwiftUI

let screenSize = UIScreen.main.bounds.size
let defaultTime: Double = 30

struct Timerz: View {
    @State private var selectedTime: Double?
    @State private var time: Double = defaultTime
    @State private var steps: Double = 10
    @State private var isTimerRunning = false
    @State private var isTimerPaused = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Spacer()
                
                CircularTimerView(
                    selectedTime: selectedTime,
                    time: $time,
                    isTimerRunning: $isTimerRunning,
                    isTimerPaused: $isTimerPaused
                )
                
                ActionBarView(
                    selectedTime: $selectedTime,
                    time: $time, steps: $steps,
                    isTimerRunning: $isTimerRunning,
                    isTimerPaused: $isTimerPaused
                )
                
                StopButtonView(
                    selectedTime: $selectedTime,
                    time: $time,
                    isTimerRunning: $isTimerRunning,
                    isTimerPaused: $isTimerPaused
                )
                
            }
            .padding(.bottom, 50)
            .onReceive(timer) { _ in
                timerUpdate()
            }
            
            TitleView()
        }
    }
    
    private func timerUpdate() {
        guard isTimerRunning else { return }
        guard !isTimerPaused else { return }
        
        if time > 0 {
            time -= 1
        }
        
        if time == 0 && isTimerRunning {
            stopTimer()
        }
    }
    
    private func stopTimer() {
        time = selectedTime ?? defaultTime
        selectedTime = nil
        isTimerRunning = false
        isTimerPaused = true
    }
}

struct StopButtonView: View {
    @Binding var selectedTime: Double?
    @Binding var time: Double
    @Binding var isTimerRunning: Bool
    @Binding var isTimerPaused: Bool
    
    var body: some View {
        Button(action: {
            stopTimer()
        }, label: {
            Label("Stop", systemImage: "stop.circle.fill")
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .frame(
                    width: 200,
                    height: 60)
                .background(Color.clear)
                .foregroundColor(.red)
                .scaleEffect(isTimerRunning ? 1 : 0)
        })
        .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0))
        .offset(x: 0, y: isTimerRunning ? 0 : 200)
    }
    
    private func stopTimer() {
        vibrateError()
        time = selectedTime ?? defaultTime
        selectedTime = nil
        isTimerRunning = false
        isTimerPaused = true
    }
    
    private func vibrateError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

struct TitleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("One minute timer")
                .font(.system(size: 35, weight: .medium))
                .padding(20)
            Spacer()
        }
    }
}

// MARK: PREVIEW
struct Timerz_Previews: PreviewProvider {
    static var previews: some View {
        Timerz()
    }
}
