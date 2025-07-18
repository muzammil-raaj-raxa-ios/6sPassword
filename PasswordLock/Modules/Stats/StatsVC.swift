//
//  StatsVC.swift
//  PasswordLock
//
//  Created by r a a j on 09/07/2025.
//

import UIKit

struct Achievement {
    let image: UIImage
    let title: String
    let description: String
    var isUnlocked: Bool
}


class StatsVC: UIViewController {
    
    @IBOutlet weak var fastestTimeLabel: UILabel!
    @IBOutlet weak var bestStreakLabel: UILabel!
    @IBOutlet weak var bestAccuracyLabel: UILabel!
    @IBOutlet weak var totalGamesLabel: UILabel!
    @IBOutlet weak var statsTV: UITableView!
    
    //MARK: - ACHIEVEMENTS ARRAY
    var achievements: [Achievement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateAchievements()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func setupUI() {
        bestStreakLabel.text = UserDefaultsManager.shared.bestStreak ?? "0"
        bestAccuracyLabel.text = UserDefaultsManager.shared.bestAccuracy ?? "0%"
        totalGamesLabel.text = UserDefaultsManager.shared.totalGames ?? "0"
        
        if let fastest = UserDefaultsManager.shared.fastestTime,
           let time = Double(fastest) {
            fastestTimeLabel.text = "\(String(format: "%.1f", time))s"
        } else {
            fastestTimeLabel.text = "0.0s"
        }
    }
    
    func setupTableView() {
        statsTV.isHidden = true
        statsTV.delegate = self
        statsTV.dataSource = self
        statsTV.register(UINib(nibName: "AcheivementCell", bundle: nil), forCellReuseIdentifier: "AcheivementCell")
    }
    
    func populateAchievements() {
        let locked = true
        
        func image(_ systemName: String) -> UIImage {
            return UIImage(systemName: systemName) ?? UIImage()
        }
        
        achievements = [
            // Easy
            .init(image: image("play.circle"), title: "Getting Started", description: "Play your first game", isUnlocked: locked),
        ]
    }
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    // Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "PRIMARY")
        
        
        let label = UILabel()
        label.text = "Achievements"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcheivementCell", for: indexPath) as? AcheivementCell else { return UITableViewCell() }
        
        let item = achievements[indexPath.row]
        cell.img.image = item.image
        cell.title.text = item.title
        cell.desc.text = item.description
        cell.isUnclockedImg.isHidden = !item.isUnlocked // You can use a lock/unlock image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

