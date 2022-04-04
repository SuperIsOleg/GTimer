//
//  FactoryImage.swift
//  GTimer
//
//  Created by Home on 4.04.22.
//

import UIKit

class FactoryImage {
    
    static func getImage(named: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: named)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
