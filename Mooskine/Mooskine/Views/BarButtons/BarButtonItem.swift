//
//  BarButtonItem.swift
//  Mooskine
//
//  Created by Chris Paine on 2/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class BarButtonItem: UIBarButtonItem {
    var buttonView: BarButton!
    
    var onPress: (() -> Void)?
    
    convenience init(image: UIImage, onPress: @escaping () -> Void) {
        self.init()
        
        self.onPress = onPress

        buttonView = BarButton(image: image)
        buttonView.addTarget(self, action: #selector(updateState), for: .touchUpInside)
        customView = buttonView
    }
    
    @objc private func updateState() {
        buttonView.isSelected = !buttonView.isSelected
        
        onPress?()
    }
}
