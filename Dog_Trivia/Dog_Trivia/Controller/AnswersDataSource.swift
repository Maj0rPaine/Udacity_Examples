//
//  AnswersDataSource.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/25/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import UIKit

protocol AnswersDataSourceDelegate: AnyObject {
    func finishedFetch()
    func didAnswer(correctly: Bool)
}

class AnswersDataSource<CellType: UICollectionViewCell>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: AnswersDataSourceDelegate?

    var collectionView: UICollectionView!
    
    var breeds: [String] = []
    
    var randomBreeds: [String] = []
    
    var breedType: String!
    
    var correctAnswerCell: AnswerCollectionViewCell? {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let answerCell = answerCell(at: indexPath),
                answerCell.label.text == breedType {
                return answerCell
            }
        }
        
        return nil
    }
    
    var selectedAnswerCell: AnswerCollectionViewCell? {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            return answerCell(at: indexPath)
        }
        
        return nil
    }
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        DogAPI.requestAllBreeds { (dogBreeds, error) in
            if let dogBreeds = dogBreeds {
                self.breeds = dogBreeds.breeds
                self.delegate?.finishedFetch()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.randomBreeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as! AnswerCollectionViewCell
        cell.label.text = randomBreeds[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSelectedCell()
    }
}

extension AnswersDataSource {
    func loadAnswers() {
        randomBreeds = breeds.randomBreeds(breedType: breedType)
        collectionView.reloadData()
        setAnswersEnabled()
    }
    
    func answerCell(at indexPath: IndexPath) -> AnswerCollectionViewCell? {
        return collectionView.cellForItem(at: indexPath) as? AnswerCollectionViewCell
    }
    
    func showCorrectCell() {
        correctAnswerCell?.setCellState(state: .selected)
    }
    
    func checkSelectedCell() {
        guard let selectedCell = selectedAnswerCell else { return }
        
        let didSelectCorrectCell = selectedCell == correctAnswerCell
        selectedCell.selectedCorrectCell = didSelectCorrectCell
        
        // Show correct answer
        if !didSelectCorrectCell {
            correctAnswerCell?.selectedCorrectCell = true
        }
        
        delegate?.didAnswer(correctly: didSelectCorrectCell)
    }
    
    func setAnswersEnabled(enabled: Bool = true) {
        DispatchQueue.main.async {
            self.collectionView.isUserInteractionEnabled = enabled
        }
    }
}
