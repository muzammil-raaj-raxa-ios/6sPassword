//
//  SplashVC.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    @IBOutlet weak var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView.animation = LottieAnimation.named("typing")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animationView.stop()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
    }

}
