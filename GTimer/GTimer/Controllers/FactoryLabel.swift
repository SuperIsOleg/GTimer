//
//  FactoryLabel.swift
//  GTimer
//
//  Created by Home on 21.03.22.
//

import UIKit

class FactoryLabel {
    
    static func getTitleLabel(textTitleLabel: String, sizeTitle: Int) -> UILabel {
        
        let textLabel = UILabel()
       
        textLabel.font = UIFont.systemFont(ofSize: CGFloat(sizeTitle))
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.text = textTitleLabel
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }
}
