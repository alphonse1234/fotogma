//
//  LoginTextFieldView.swift
//  fotogma
//
//  Created by 장창순 on 2016. 3. 2..
//  Copyright © 2016년 fotogma. All rights reserved.
//

import UIKit

class LoginTextFieldView: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.backgroundColor = UIColor(red: 94 / 255, green: 94 / 255, blue: 94 / 255, alpha: 0.8).CGColor
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1.0)])

        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
