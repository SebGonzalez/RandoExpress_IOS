//
//  eee.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

@IBDesignable
class RandoViewCell: UITableViewCell {
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ville: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
