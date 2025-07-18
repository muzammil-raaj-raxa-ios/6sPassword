//
//  ChallengeVC.swift
//  PasswordLock
//
//  Created by r a a j on 02/07/2025.
//

import UIKit
import Lottie
import WidgetKit

class ChallengeVC: BaseViewController {
    
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var randomWord: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var currentRandomWord: String = ""
    var totaltime: Int?
    var totalRounds: Int?
    var currentRound: Int = 0
    var correctCount: Int = 0
    var accuracy: Int = 0
    var countdownTimer: Timer?
    var streakCount: Int = 0
    var streakBarButton: UIBarButtonItem!
    var wordStartTime: Date?
    var fastestTime: Double = Double(UserDefaultsManager.shared.fastestTime ?? "0") ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Re-enable swipe
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // Invalidate countdown timer
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    func setupBarButtons() {
        // Custom back button
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: chevronImage, style: .plain, target: self, action: #selector(customBackButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        // Streak bar button
        streakBarButton = UIBarButtonItem(title: "🔥 Streak: 0", style: .plain, target: nil, action: nil)
        streakBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = streakBarButton
    }
    
    func setupUI() {
        animationView.isHidden = true
        addRoundedBorderView(view: mainView, cornerRadius: 20, borderWidth: 2, borderColor: .white)
        
        tf.delegate = self
        currentRound = 0  // Start at 0, increase in gameOver
        roundLabel.text = "1"  // Starting round label
        correctLabel.text = "0/\(totalRounds ?? 0)"
        accuracyLabel.text = "0%"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startGame()
        }
    }
    
    func updateStreakBar() {
        streakBarButton.title = "🔥 Streak: \(streakCount)"
    }
    
    func generateRandomWord() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let randomString = String((0..<8).map { _ in
            chars.randomElement()!
        })
        return randomString
    }
    
    func startProgressCountdown() {
        let totalTime: Float = Float(totaltime ?? 6)  // Replace hardcoded 6.0
        let interval: Float = 0.005 // update every 50ms
        var elapsed: Float = 0.0
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
            elapsed += interval
            let progress = max(0.0, 1.0 - (elapsed / totalTime))
            self.progressView.setProgress(progress, animated: true)
            
            if elapsed >= totalTime {
                timer.invalidate()
                self.gameOver()
            }
        }
    }
    
    func startGame() {
        currentRandomWord = generateRandomWord()
        randomWord.setText(currentRandomWord, withLetterSpacing: 2)
        progressView.progress = 1.0
        wordStartTime = Date()
        startProgressCountdown()
        tf.becomeFirstResponder()
    }
    
    func gameOver() {
        tf.resignFirstResponder()
        
        if tf.text != currentRandomWord {
            streakCount = 0
            updateStreakBar()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.typingView.shake()
            }
        } else {
            showConFetti()
            tf.isSecureTextEntry = false
            correctCount += 1
            streakCount += 1
            updateStreakBar()
            
            // ✅ Save best streak on each successful round
            let savedStreak = Int(UserDefaultsManager.shared.bestStreak ?? "0") ?? 0
            if streakCount > savedStreak {
                UserDefaultsManager.shared.bestStreak = "\(streakCount)"
            }
            
            // ✅ Update fastest time
            if let start = wordStartTime {
                let timeTaken = Date().timeIntervalSince(start)
                let savedFastest = Double(UserDefaultsManager.shared.fastestTime ?? "0") ?? 0
                if savedFastest == 0 || timeTaken < savedFastest {
                    UserDefaultsManager.shared.fastestTime = String(format: "%.1f", timeTaken)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.tf.text = ""
            self.tf.isSecureTextEntry = true
            self.currentRound += 1
            
            // Check if the game should continue
            if self.currentRound <= self.totalRounds ?? 0 {
                self.roundLabel.text = "\(self.currentRound)"
                self.correctLabel.text = "\(self.correctCount)/\(self.totalRounds ?? 0)"
                let accuracy: Int = Int((Double(self.correctCount) / Double(self.totalRounds ?? 0)) * 100)
                self.accuracyLabel.text = "\(accuracy)%"
                self.startGame()
            } else {
                // Final update on game over
                self.roundLabel.text = "\(self.totalRounds ?? 0)"
                self.randomWord.text = "GAMEOVER"
                self.correctLabel.text = "\(self.correctCount)/\(self.totalRounds ?? 0)"
                let finalAccuracy = Int((Double(self.correctCount) / Double(self.totalRounds ?? 0)) * 100)
                self.accuracyLabel.text = "\(finalAccuracy)%"
                self.correctLabel.text = "\(self.correctCount)/\(self.totalRounds ?? 0)"
                
                self.updateTotalGames()
                self.updateBestAccuracy(currentAccuracy: finalAccuracy)
                
                // Show Alert
                self.showGameOverAlert()
            }
        }
    }
    
    func updateTotalGames() {
        let current = Int(UserDefaultsManager.shared.totalGames ?? "0") ?? 0
        UserDefaultsManager.shared.totalGames = "\(current + 1)"
    }
    
    func updateBestAccuracy(currentAccuracy: Int) {
        let savedAccuracyStr = UserDefaultsManager.shared.bestAccuracy?.replacingOccurrences(of: "%", with: "") ?? "0"
        let savedAccuracy = Int(savedAccuracyStr) ?? 0
        
        if currentAccuracy > savedAccuracy {
            UserDefaultsManager.shared.bestAccuracy = "\(currentAccuracy)%"
        }
    }
    
    func showConFetti() {
        animationView.isHidden = false
        animationView.animation = LottieAnimation.named("confetti")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animationView.pause()
            self.animationView.isHidden = true
        }
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "What do you want to do?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartGame()
        }))
        
        alert.addAction(UIAlertAction(title: "Go to Home", style: .cancel, handler: { _ in
            self.popToHome()
        }))
        
        present(alert, animated: true)
    }
    
    func restartGame() {
        // Reset all variables
        self.currentRound = 1
        self.correctCount = 0
        self.accuracyLabel.text = "0%"
        self.correctLabel.text = "0/\(self.totalRounds ?? 0)"
        self.roundLabel.text = "\(self.currentRound)"
        self.tf.text = ""
        self.randomWord.text = "GAME STARTING"
        
        // Start new game
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startGame()
        }
    }
    
    func popToHome() {
        // Pops two view controllers from navigation stack
        if let nav = self.navigationController {
            let viewControllers = nav.viewControllers
            if viewControllers.count >= 3 {
                nav.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            } else {
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func customBackButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you really want to go back? Your progress will be lost.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, Go Back", style: .destructive, handler: { _ in
            self.popToHome()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tf.text == currentRandomWord {
            if let start = wordStartTime {
                let timeTaken = Date().timeIntervalSince(start)
                let savedFastest = Double(UserDefaultsManager.shared.fastestTime ?? "0") ?? 0
                if savedFastest == 0 || timeTaken < savedFastest {
                    UserDefaultsManager.shared.fastestTime = String(format: "%.1f", timeTaken)
                    UserDefaults(suiteName: "group.com.raaj.PasswordLock")?.set("3.5", forKey: "fastestTime")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        
        return super.textFieldShouldReturn(textField)
    }
    
}
