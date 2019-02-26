//
//  AnswerCollectionViewCell.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/23/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import UIKit

enum CellState {
    case initial
    case selected
    case correct
    case incorrect
}

class AnswerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = { return String(describing: AnswerCollectionViewCell.self) }()

    @IBOutlet weak var label: UILabel!
    
    var selectedCorrectCell = false {
        didSet {
            if selectedCorrectCell {
                setCellState(state: .correct)
            } else {
                setCellState(state: .incorrect)
            }
        }
    }
    
    override var isSelected: Bool  {
        didSet {
            if isSelected {
                setCellState(state: .selected)
            } else {
                setCellState(state: .initial)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 2
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
        setCellState(state: .initial)
    }
}

extension AnswerCollectionViewCell {
    func setCellState(state: CellState) {
        switch state {
        case .initial:
            updateColor(for: state)
            break
        case .selected:
            updateColor(color: #colorLiteral(red: 0.2588235294, green: 0.4705882353, blue: 0.9607843137, alpha: 1) , for: state)
            break
        case .correct:
            updateColor(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: state)
            break
        case .incorrect:
            updateColor(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: state)
            break
        }
    }
    
    func updateColor(color: UIColor = .clear, for state: CellState) {
        switch state {
        case .initial:
            layer.borderColor = UIColor.lightGray.cgColor
            backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if label != nil {
                label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        default:
            layer.borderColor = color.cgColor
            backgroundColor = color
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
