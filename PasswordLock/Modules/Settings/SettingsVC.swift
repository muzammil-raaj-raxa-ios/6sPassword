//
//  SettingsVC.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var settingTV: UITableView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    
    var listings: [SettingModel] = [
        SettingModel(title: "Sound Effects", isOn: true),
        SettingModel(title: "Haptic Feedback", isOn: true),
        SettingModel(title: "Show Timer", isOn: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        settingTV.delegate = self
        settingTV.dataSource = self
        settingTV.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        
        addRoundedBorder(btn: rateBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
        addRoundedBorder(btn: shareBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
        addRoundedBorder(btn: privacyBtn, cornerRadius: 30, borderWidth: 1, borderColor: .white)
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else { return UITableViewCell() }
        
        let item = listings[indexPath.row]
        
        cell.settingLabel.text = item.title
        cell.settingSwitch.isOn = item.isOn
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

struct SettingModel {
    let title: String
    let isOn: Bool
}
