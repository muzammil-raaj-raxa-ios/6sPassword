//
//  ViewController.swift
//  PasswordLock
//
//  Created by r a a j on 26/06/2025.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var randomWord: UILabel!
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var seconds = 6
    let label = UILabel()
    var timer: Timer?
    var currentRandomWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.isHidden = true
        resetBtn.isHidden = true
        currentRandomWord = generateRandomWord()
        randomWord.text = currentRandomWord
        
        tf.addBottomBorder(lineColor: .black)
        tf.becomeFirstResponder()
        tf.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupTimerLabel()
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        tf.isUserInteractionEnabled = true
        tf.becomeFirstResponder()
        tf.addBottomBorder(lineColor: .black)
        tf.text = ""
        seconds = 6
        resetBtn.isHidden = true
        setupTimerLabel()
        currentRandomWord = generateRandomWord()
        randomWord.text = currentRandomWord
    }
    
    func showConFetti() {
        animationView.animation = LottieAnimation.named("confetti")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animationView.pause()
            self.animationView.isHidden = true
        }
    }
    
    func generateRandomWord() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let randomString = String((0..<8).map { _ in
            chars.randomElement()!
        })
        return randomString
    }
    
    func setupTimerLabel() {
        label.text = "0:\(seconds)"
        label.textColor = .red
        label.font = .systemFont(ofSize: 18, weight: .regular)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: label)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        label.text = "0:\(seconds)"
        if seconds == 0 {
            timer?.invalidate()
            resetBtn.isHidden = false
            tf.resignFirstResponder()
            tf.isUserInteractionEnabled = false
            if currentRandomWord != tf.text ?? "" {
                tf.addBottomBorder(lineColor: .red)
            } else {
                animationView.isHidden = false
                showConFetti()
            }
        }
    }

}

extension ViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.length > 0 {
            return false
        }
        return true
    }
}


extension UITextField {

    func addBottomBorder(lineColor: UIColor) {
        let bottomline = CALayer()
        bottomline.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
        bottomline.backgroundColor = lineColor.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomline)
    }

}
