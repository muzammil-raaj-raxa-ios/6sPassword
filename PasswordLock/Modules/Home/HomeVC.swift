//
//  HomeVC.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var practiceBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRoundedBorderBtn(btn: challengeBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
        addRoundedBorderBtn(btn: practiceBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
    }
    
    @IBAction func challengeBtn(_ sender: Any) {
        let vc = ChallengeSettingsVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func practiceBtn(_ sender: Any) {
        let vc = PracticeVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
