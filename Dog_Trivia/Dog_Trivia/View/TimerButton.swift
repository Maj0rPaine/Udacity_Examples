//
//  TimerButton.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/23/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import UIKit

protocol TimerButtonDelegate: AnyObject {
    func timerDidFinish()
}

enum TimerState {
    case running
    case finished
    case correct
    case incorrect
}

class TimerButton: UIButton {
    weak var delegate: TimerButtonDelegate?
    
    var timer = Timer()
    
    var isTimerRunning = false
    
    var seconds = 0 {
        didSet {
            setTimerState(state: .running)
            
            if seconds == 0 {
                setTimerState(state: .finished)
                resetTimer()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = frame.width / 2
    }
}

extension TimerButton {
    func setTimerState(state: TimerState) {
        switch state {
        case .running:
            updateUI(title: "\(seconds)", color: #colorLiteral(red: 0.2588235294, green: 0.4705882353, blue: 0.9607843137, alpha: 1), for: state)
            break
        case .finished:
            updateUI(title: "Time's up!", color: #colorLiteral(red: 0.2588235294, green: 0.4705882353, blue: 0.9607843137, alpha: 1), for: state)
            break
        case .correct:
            updateUI(title: "Correct", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: state)
            break
        case .incorrect:
            updateUI(title: "Incorrect", color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: state)
            break
        }
    }
    
    func updateUI(title: String, color: UIColor, for state: TimerState) {
        setTitle(title, for: .normal)
        backgroundColor = color
    }

    func runTimer() {
        if isHidden {
            isHidden = false
        }
        
        seconds = 10
        
        if !isTimerRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.seconds -= 1
            }
            
            isTimerRunning = true
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        
        isTimerRunning = false
    }

    func resetTimer() {
        stopTimer()
        
        delegate?.timerDidFinish()
    }
    
    func updateTimer(correctAnswer: Bool) {
        stopTimer()
        
        if correctAnswer {
            setTimerState(state: .correct)
        } else {
            setTimerState(state: .incorrect)
        }
    }
}
