//
//  PracticeVC.swift
//  PasswordLock
//
//  Created by r a a j on 15/07/2025.
//

import UIKit

class PracticeVC: BaseViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var randomWord: UILabel!
    @IBOutlet weak var tf: UITextField!
    
    let times = ["3 s", "4 s", "5 s", "6 s", "7 s", "8 s", "9 s",]
    var selectedTime: String = "3 s"
    var countdownTimer: Timer?
    var totaltime: Int?
    var currentRandomWord: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        addRoundedBorderView(view: mainView, cornerRadius: 20, borderWidth: 2, borderColor: .white)
        setupTimeMenu()
        tf.delegate = self
        tf.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Invalidate countdown timer
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    @IBAction func startBtn(_ sender: Any) {
        startRound()
    }
    
    func setupTimeMenu() {
        timeButton.setTitle(selectedTime, for: .normal)
        
        let timeActions = times.map { time in
            UIAction(
                title: time,
                state: (time == selectedTime) ? .on : .off,
                handler: { [weak self] _ in
                    self?.selectedTime = time
                    self?.timeButton.setTitle(time, for: .normal)
                    self?.setupTimeMenu()
                }
            )
        }
        
        let menu = UIMenu(title: "", options: .singleSelection, children: timeActions)
        timeButton.menu = menu
        timeButton.showsMenuAsPrimaryAction = true
    }
    
    func startRound() {
        tf.isUserInteractionEnabled = true
        tf.becomeFirstResponder()
        startButton.isUserInteractionEnabled = false
        timeButton.isUserInteractionEnabled = false
        let totalTime: Float = Float(Int(selectedTime.replacingOccurrences(of: " s", with: "")) ?? 0)
        let interval: Float = 0.005
        var elapsed: Float = 0.0
        progressView.progress = 1
        currentRandomWord = generateRandomWord()
        randomWord.setText(currentRandomWord, withLetterSpacing: 2)
        
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
            elapsed += interval
            let progress = max(0.0, 1.0 - (elapsed / totalTime))
            self.progressView.setProgress(progress, animated: true)
            
            if elapsed >= totalTime {
                timer.invalidate()
                self.roundOver()
            }
        }
    }
    
    func roundOver() {
        if tf.text == currentRandomWord {
            tf.isSecureTextEntry = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.reset()
            }
        } else {
            typingView.shake()
            reset()
        }
    }
    
    func reset() {
        timeButton.isUserInteractionEnabled = true
        startButton.isUserInteractionEnabled = true
        randomWord.text = "ROUND OVER"
        tf.resignFirstResponder()
        tf.text = ""
        tf.isUserInteractionEnabled = false
    }
    
    func generateRandomWord() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let randomString = String((0..<8).map { _ in
            chars.randomElement()!
        })
        return randomString
    }

}
