//
//  TimerView.swift
//  Timer
//
//  Created by Isabelle Fang on 9/9/25.
//

import SwiftUI

extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60
        
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}

class TimerViewModel: ObservableObject {
    
    
    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59
    
    // represents the different states a timer can be in
    enum TimerState {
        case active
        case paused
        case resumed
        case cancelled
    }
    
    // Private properties
    private var timer = Timer()
    private var totalTimerforCurrentSelection: Int {
        (selectedHoursAmount * 3600) + (selectedMinutesAmount * 60) + selectedSecondsAmount
    }
    
    // Public properties
    @Published var selectedHoursAmount = 10
    @Published var selectedMinutesAmount = 10
    @Published var selectedSecondsAmount = 10
    
    @Published var state: TimerState = .cancelled {
        didSet {
            // modelled as a state machine for easier testing
            // and a cleaner / more readable implementation
            switch state {
            case .cancelled:
                // cancel the timer and reset all progress properties
                timer.invalidate()
                secondsToCompletion = 0
                progress = 0
                
            case .active:
                // starts the timer and sets all progress properties
                // to their initial values
                startTimer()
                
                secondsToCompletion = totalTimerforCurrentSelection
                progress = 1.0
                
                updateCompletionDate()
                
            case .paused:
                // we want to pause the timer, but we don't want
                // to change the state of our progress properties
                // (secondsToCompletion)
                timer.invalidate()
                
            case .resumed:
                // resumes a timer
                startTimer()
                
                // we don't know how long we've been paused for, so we
                // need to update our ETA
                updateCompletionDate()
            }
        }
        
    }
    
    // Powers the Progress View
    @Published var secondsToCompletion = 0
    @Published var progress: Float = 0.0
    @Published var completionDate = Date.now
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in guard let self else { return }
            
            self.secondsToCompletion -= 1
            self.progress = Float(self.secondsToCompletion) / Float(self.totalTimerforCurrentSelection)
            
            // we can't do <= here because we need to ensure the animation
            // has time to finish runninng (see .linear(duration: 1.0))
            if self.secondsToCompletion < 0 {
                self.state = .cancelled
            }
        })
    }
    
    
    private func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(secondsToCompletion))
    }
    
}

struct TimerView: View {
    @StateObject private var model = TimerViewModel()
    
    var timerControl: some View {
        HStack {
            Button("Cancel") {
                model.state = .cancelled
            }
            .buttonStyle(CancelButtonStyle())
            
            Spacer()
            
            switch model.state {
            case .cancelled:
                Button("Start") {
                    model.state = .active
                }
                .buttonStyle(StartButtonStyle())
            case .paused:
                Button("Resume") {
                    model.state = .resumed
                }
                .buttonStyle(StartButtonStyle())
            case .active, .resumed:
                Button("Pause"){
                    model.state = .paused
                }
                .buttonStyle(PauseButtonStyle())
            }
        }
        .padding(.horizontal, 32)
    }
    
    var timePickerControl: some View {
        HStack() {
            TimePickerView(title: "hours",
                range: model.hoursRange,
                binding: $model.selectedHoursAmount)
            TimePickerView(title: "min",
                range: model.minutesRange,
                binding: $model.selectedMinutesAmount)
            TimePickerView(title: "sec",
                range: model.secondsRange,
                binding: $model.selectedSecondsAmount)
        }
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
    
    var progressView : some View {
        ZStack() {
            withAnimation {
                CircularProgressView(progress: $model.progress)
            }
            
            VStack {
                Text(model.secondsToCompletion.asTimestamp)
                               .font(.largeTitle)
                HStack {
                    Image(systemName: "bell.fill")
                    Text(model.completionDate, format: .dateTime.hour().minute())
                }
            }
        }
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
    
    var body: some View {
        VStack {
            if model.state == .cancelled{
                timePickerControl
            }
            else {
                progressView
            }
            
            timerControl
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .foregroundColor(.white)
    }
    
}

#Preview {
    TimerView()
}
