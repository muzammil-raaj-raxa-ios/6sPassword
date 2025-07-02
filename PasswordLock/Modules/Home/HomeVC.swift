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
        
        addRoundedBorder(btn: challengeBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
        addRoundedBorder(btn: practiceBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
    }

}
