//
//  ViewController.swift
//  MyFirstGame
//
//  Created by Yunus Emre Bitkay on 5.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //Variables
    var score = 0
    var highScore = 0
    var timer = Timer()
    var hideTimer = Timer()
    var counter = 0
    var catArray = [UIImageView]()

    //View
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var catOne: UIImageView!
    @IBOutlet weak var catTwo: UIImageView!
    @IBOutlet weak var catThree: UIImageView!
    @IBOutlet weak var catFour: UIImageView!
    @IBOutlet weak var catFive: UIImageView!
    @IBOutlet weak var catSix: UIImageView!
    @IBOutlet weak var catSeven: UIImageView!
    @IBOutlet weak var catEight: UIImageView!
    @IBOutlet weak var catNine: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Score Label
        scoreLabel.text = "Score: \(score)"
        
        //Cat Array Definition
        catArray = [catOne, catTwo, catThree, catFour, catFive, catSix, catSeven, catEight, catNine]
        
        //Run Get Highscore Function and Hide Cat Function
        hideCat()
        getHighscore()
        catAllowTouch()
        replayGame()
        setRecognizer()
       
    }
    
    func setRecognizer(){
        for cat in catArray{
            cat.addGestureRecognizer(addRecognizer())
        }
    }
    
    func addRecognizer() -> UITapGestureRecognizer{
        var gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScoreFunction))
        return gestureRecognizer
    }
        
    //Get Highscore Function
    func getHighscore(){
        //Get high score from UserDefaults
        let storedHighscore = UserDefaults.standard.object(forKey: "Highscore")
    
        //Checking highscore
        if storedHighscore == nil {
            highScore = 0
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        if let newScore = storedHighscore as? Int{
            highScore = newScore
            highscoreLabel.text = "Highscore: \(highScore)"
        }
    }
    
    //Hide Cat Function
    @objc func hideCat(){
        //Cat Array
        for cat in catArray{
            cat.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(catArray.count-1)))
        catArray[random].isHidden = false
    }
    
    
    func replayGame(){
        score = 0
        scoreLabel.text = "Score: \(score)"
        counter = 30
        timerLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideCat), userInfo: nil, repeats: true)
    }
    
    //Allow Touch Cat
    func catAllowTouch(){
        for cat in catArray{
            cat.isUserInteractionEnabled = true
        }
    }
    
    //Add point to score
    @objc func increaseScoreFunction(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    //Down Time
    @objc func countDown(){
        counter -= 1
        timerLabel.text = "\(counter)"
        
        //Stop Time
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            //Hidden Cats
            for cat in catArray{
                cat.isHidden = true
            }
            
            //Highscore
            if self.score > self.highScore{
                self.highScore = self.score
                self.highscoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.setValue(self.highScore, forKey: "Highscore")
            }
            
            //Alert
            let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let buttonOkey = UIAlertAction(title: "Okey", style: UIAlertAction.Style.cancel, handler: nil)
            let buttonReplay = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                self.replayGame()
            }
            alert.addAction(buttonOkey)
            alert.addAction(buttonReplay)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

