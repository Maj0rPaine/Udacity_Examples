//
//  ViewController.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/22/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerButton: TimerButton!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    var answersDataSource: AnswersDataSource<AnswerCollectionViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        answersDataSource = AnswersDataSource(collectionView: answersCollectionView)
        answersDataSource.delegate = self
        
        timerButton.delegate = self
    }
}

extension ViewController {
    func fetchImage(delay: Double = 0) {
        answersDataSource.setAnswersEnabled(enabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            DogAPI.requestRandomImage(completionHandler: self.handleRandomImageResponse(dogImage:error:))
        }
    }
    
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?) {
        guard let imageURL = URL(string: dogImage?.message ?? ""),
            let breedType = dogImage?.breedType else { return }
        
        self.answersDataSource.breedType = breedType
        
        DogAPI.requestImageFile(url: imageURL) { (image, error) in
            self.handleImageFileResponse(image: image, error: error)
        }
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.dogImageView.image = image
            self.answersDataSource.loadAnswers()
            self.timerButton.runTimer()
        }
    }
}

extension ViewController: TimerButtonDelegate {
    func timerDidFinish() {
        answersDataSource.showCorrectCell()
        
        fetchImage(delay: 2)
    }
}

extension ViewController: AnswersDataSourceDelegate {
    func finishedFetch() {
        fetchImage()
    }
    
    func didAnswer(correctly: Bool) {
        timerButton.updateTimer(correctAnswer: correctly)
        
        fetchImage(delay: 2)
    }
}
