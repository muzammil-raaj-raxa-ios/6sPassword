//
//  Constants.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit

//MARK: - PUBLIC METHODS
func addRoundedBorderBtn(btn: UIButton, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {

    btn.layer.cornerRadius = cornerRadius
    btn.layer.borderWidth = borderWidth
    btn.layer.borderColor = borderColor.cgColor
    btn.layer.masksToBounds = true
}

func addRoundedBorderView(view: UIView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {

    view.layer.cornerRadius = cornerRadius
    view.layer.borderWidth = borderWidth
    view.layer.borderColor = borderColor.cgColor
    view.layer.masksToBounds = true
}


//MARK: - EXTENSIONS
extension UITextField {
    func addBottomBorder(lineColor: UIColor) {
        let bottomline = CALayer()
        bottomline.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
        bottomline.backgroundColor = lineColor.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomline)
    }
}

extension UILabel {
    func setText(_ text: String, withLetterSpacing spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}

extension UIView {
    
    func shake(duration: CFTimeInterval = 1, repeatCount: Float = 8, offset: CGFloat = 10) {
        
        // Set the red border
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        
        // Remove any existing shake animation
        self.layer.removeAnimation(forKey: "shake")
        
        // Shake animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = duration / Double(repeatCount * 2)
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = -offset
        animation.toValue = offset
        self.layer.add(animation, forKey: "shake")
        
        // Cancel any pending reset operations
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resetBorder), object: nil)
        
        // Schedule new reset
        self.perform(#selector(resetBorder), with: nil, afterDelay: duration)
    }
    
    @objc private func resetBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
}


//achievements = [
//    // Easy
//    .init(image: image("play.circle"), title: "Getting Started", description: "Play your first game", isUnlocked: locked),
//    .init(image: image("bolt.fill"), title: "Fast Fingers", description: "Type a word under 5s", isUnlocked: locked),
//    .init(image: image("flame"), title: "First Streak", description: "Get a 3-win streak", isUnlocked: locked),
//    .init(image: image("lightbulb"), title: "Quick Learner", description: "Get 50% accuracy", isUnlocked: locked),
//    .init(image: image("timer"), title: "Explorer", description: "Try all time durations", isUnlocked: locked),
//    .init(image: image("thermometer"), title: "Warm Up", description: "Complete 5 games", isUnlocked: locked),
//    .init(image: image("person"), title: "Typing Rookie", description: "Reach 60% accuracy", isUnlocked: locked),
//    .init(image: image("flag"), title: "Ready Set Go!", description: "Complete a 3 round game", isUnlocked: locked),
//    .init(image: image("questionmark.circle"), title: "Curious Cat", description: "Check your stats screen", isUnlocked: locked),
//    .init(image: image("3.circle"), title: "Just Warming Up", description: "Score 3 correct answers in one game", isUnlocked: locked),
//    
//    // Medium
//    .init(image: image("target"), title: "Accuracy King", description: "Reach 80% accuracy", isUnlocked: locked),
//    .init(image: image("flame.fill"), title: "Streak Master", description: "Reach a 10-win streak", isUnlocked: locked),
//    .init(image: image("hare.fill"), title: "Speed Demon", description: "Type in under 3 seconds", isUnlocked: locked),
//    .init(image: image("keyboard"), title: "Typist", description: "Play 25 games", isUnlocked: locked),
//    .init(image: image("repeat.circle"), title: "Challenge Lover", description: "Play 10 rounds in one game", isUnlocked: locked),
//    .init(image: image("checkmark.seal"), title: "Consistent", description: "Get 70%+ accuracy in 3 games", isUnlocked: locked),
//    .init(image: image("scope"), title: "Sharp Shooter", description: "Reach 90% accuracy once", isUnlocked: locked),
//    .init(image: image("brain.head.profile"), title: "Quick Thinker", description: "Type 3 consecutive words under 4s", isUnlocked: locked),
//    .init(image: image("hammer"), title: "Grinder", description: "Play 50 games", isUnlocked: locked),
//    .init(image: image("arrow.2.squarepath"), title: "Explorer II", description: "Play with all round counts", isUnlocked: locked),
//    
//    // Hard
//    .init(image: image("crown"), title: "Typing God", description: "Reach 100% accuracy", isUnlocked: locked),
//    .init(image: image("bolt.circle"), title: "Lightning Speed", description: "Type in under 2 seconds", isUnlocked: locked),
//    .init(image: image("infinity.circle"), title: "Endurance Champ", description: "Play 100 games", isUnlocked: locked),
//    .init(image: image("flame.circle"), title: "Streak Legend", description: "Reach a 25-win streak", isUnlocked: locked),
//    .init(image: image("eye"), title: "Iron Focus", description: "Maintain 90%+ accuracy for 5 games", isUnlocked: locked),
//    .init(image: image("stopwatch.fill"), title: "Speed Typist", description: "Average under 3s in a full game", isUnlocked: locked),
//    .init(image: image("star"), title: "Achievement Hunter", description: "Unlock 10 achievements", isUnlocked: locked),
//    .init(image: image("checkmark.circle"), title: "Flawless Victory", description: "Complete all rounds correctly in one game", isUnlocked: locked),
//    .init(image: image("cpu"), title: "One with the Code", description: "Reach 30 streaks", isUnlocked: locked),
//    .init(image: image("tornado"), title: "Typing Ninja", description: "Type 5 correct words in a row under 3s each", isUnlocked: locked)
//]
