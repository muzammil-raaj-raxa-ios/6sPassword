//
//  AcheivementCell.swift
//  PasswordLock
//
//  Created by r a a j on 09/07/2025.
//

import UIKit

class AcheivementCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var isUnclockedImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
}
