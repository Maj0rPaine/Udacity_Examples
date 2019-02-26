//
//  Note+NSManagedObject.swift
//  Mooskine
//
//  Created by Chris Paine on 1/31/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
        attributedText = NSAttributedString(string: "New Note")
    }
}
