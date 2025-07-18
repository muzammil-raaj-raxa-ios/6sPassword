//
//  BaseViewController.swift
//  PasswordLock
//
//  Created by r a a j on 04/07/2025.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollVIEW: UIScrollView!
    @IBOutlet var textFieldArray: [UITextField]!
    var autoScrollEnable = true
    var keyboardHeight: CGFloat = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardObservers()
        setupTextFields()
        prepareTapSound()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    
    func setupTextFields() {
        guard let fields = textFieldArray else { return }
        for field in fields {
            field.delegate = self
        }
    }
    
    func prepareTapSound() {
        guard let url = Bundle.main.url(forResource: "tap", withExtension: "wav") else {
            print("❌ tap.wav not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("❌ Error loading sound: \(error)")
        }
    }
    
    func playTapSound() {
        // Check if sound is enabled in UserDefaults
        guard UserDefaultsManager.shared.tapSoundEnabled else { return }
        
        audioPlayer?.stop() // in case it's still playing
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    func playHaptics() {
        // Check if sound is enabled in UserDefaults
        guard UserDefaultsManager.shared.tapHapticEnabled else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // Detect backspace
        
        if string.isEmpty && range.length == 1 {
            return false // Prevent deletion
        }

        playTapSound()
        playHaptics()
        return true // Allow all other characters
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let fields = textFieldArray else {
            textField.resignFirstResponder()
            return true
        }
        
        let sortedFields = fields.sorted { $0.tag < $1.tag }
        for next in sortedFields {
            if next.tag > textField.tag && isVisibleParentsViews(view: next) {
                next.becomeFirstResponder()
                return true
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    private func isVisibleParentsViews(view: UIView?) -> Bool {
        var current = view
        while let c = current {
            if c.isHidden || c.alpha == 0 {
                return false
            }
            current = c.superview
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let scrollView = scrollVIEW,
              let activeField = findFirstResponder(in: view) else { return }
        
        keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight + 20
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight + 20
        
        if autoScrollEnable {
            let visibleAreaHeight = view.frame.height - keyboardHeight
            let activeFieldFrame = activeField.convert(activeField.bounds, to: view)
            
            if activeFieldFrame.maxY > visibleAreaHeight {
                let offset = activeFieldFrame.maxY - visibleAreaHeight + 20
                scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let scrollView = scrollVIEW else { return }
        keyboardHeight = 0
        UIView.animate(withDuration: 0.3) {
            scrollView.contentInset.bottom = 0
            scrollView.scrollIndicatorInsets.bottom = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
