//
//  BarButton.swift
//  Mooskine
//
//  Created by Chris Paine on 2/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class BarButton: UIButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
    
    convenience init(image: UIImage) {
        self.init()
        setImage(image, for: .normal)
    }
}
