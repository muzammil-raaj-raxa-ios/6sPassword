//
//  ChallengeSettingsVC.swift
//  PasswordLock
//
//  Created by r a a j on 09/07/2025.
//

import UIKit

class ChallengeSettingsVC: UIViewController {
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var roundsButton: UIButton!
    
    let times = ["3 s", "4 s", "5 s", "6 s", "7 s", "8 s", "9 s",]
    var selectedTime: String = "3 s"
    
    let rounds = ["5", "6", "7", "8", "9", "10",]
    var selectedround: String = "5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: chevronImage, style: .plain, target: self, action: #selector(customBackButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        // Load saved values (if available)
        if let savedTime = UserDefaultsManager.shared.selectedTime {
            selectedTime = savedTime
        }
        if let savedRound = UserDefaultsManager.shared.selectedRounds {
            selectedround = savedRound
        }
        
        setupNavbar()
        setupTimeMenu()
        setupRoundMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func challengeBtn(_ sender: Any) {
        let vc = ChallengeVC()
        vc.totaltime = Int(selectedTime.replacingOccurrences(of: " s", with: "")) ?? 3
        vc.totalRounds = Int(selectedround) ?? 5
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavbar() {
        self.title = "Challenge Settings"
        self.navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .clear
        
        // Apply appearance to navigation bar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func setupTimeMenu() {
        timeButton.setTitle(selectedTime, for: .normal)
        
        let timeActions = times.map { time in
            UIAction(
                title: time,
                state: (time == selectedTime) ? .on : .off,
                handler: { [weak self] _ in
                    self?.selectedTime = time
                    UserDefaultsManager.shared.selectedTime = time
                    self?.timeButton.setTitle(time, for: .normal)
                    self?.setupTimeMenu()
                }
            )
        }
        
        let menu = UIMenu(title: "", options: .singleSelection, children: timeActions)
        timeButton.menu = menu
        timeButton.showsMenuAsPrimaryAction = true
    }
    
    func setupRoundMenu() {
        roundsButton.setTitle(selectedround, for: .normal)
        
        let roundActions = rounds.map { round in
            UIAction(
                title: round,
                state: (round == selectedround) ? .on : .off,
                handler: { [weak self] _ in
                    self?.selectedround = round
                    UserDefaultsManager.shared.selectedRounds = round
                    self?.roundsButton.setTitle(round, for: .normal)
                    self?.setupRoundMenu()
                }
            )
        }
        
        let menu = UIMenu(title: "", options: .singleSelection, children: roundActions)
        roundsButton.menu = menu
        roundsButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func customBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
