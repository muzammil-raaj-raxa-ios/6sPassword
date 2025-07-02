//
//  Constants.swift
//  PasswordLock
//
//  Created by r a a j on 01/07/2025.
//

import UIKit

func addRoundedBorder(btn: UIButton, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {

    btn.layer.cornerRadius = cornerRadius
    btn.layer.borderWidth = borderWidth
    btn.layer.borderColor = borderColor.cgColor
    btn.layer.masksToBounds = true
}
