//
//  SettingCell.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        selectionStyle = .none
    }
    
}
