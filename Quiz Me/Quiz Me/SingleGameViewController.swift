//
//  SingleGameViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/20/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit
import CoreMotion

class SingleGameViewController: UIViewController {
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var restartGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var numberOfQuestions: Int!
    var timeToNextQuestion: Int!
    var moveToNextQuestion: Bool!
    var correctAnswer: String!
    var count: Int = 0
    var userChoice: String!
    var doubleClick: Bool!
    var userScore: Int!
    
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeValues()

       // developQuestion()
//        getJSONData(questionNumber: 0)

       // getNumberOfQuestions()
    //    developQuestion()
        // Do any additional setup after loading the view.
    }
    
    func initializeValues() {
        numberOfQuestions = -2
        timeToNextQuestion = 0
        moveToNextQuestion = false
        count = 0
        doubleClick = false
        userScore = 0
        changeScoreLabel()
        restartGameButton.isHidden = true
        changeTimeLabel()
        startTimer()
    }
    
    func startTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTime)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(_ sender: Timer) {
        timeToNextQuestion! += 1
        if (count > (numberOfQuestions) && count != 0) {
            restartGameButton.isHidden = false
            sender.invalidate()
        } else {
             changeTimeLabel()
            
            if count == 0 && timeToNextQuestion == 1{
    //            moveToNextQuestion = false
    //            var playerHasAnswered = false
                getJSONData(questionNumber: count)
                count += 1
            }
            
            if timeToNextQuestion%20 == 0 {
                checkAnswer()
                clearButtons()
                doubleClick = false
                timeToNextQuestion = 0
                if count != 4 {
                    getJSONData(questionNumber: count)
                }
                count += 1
            }
        }
    }
    
    func changeTimeLabel() {
        var time = String(20 - timeToNextQuestion)
        timeLabel.text = ("Time Left: \(time)")
    }
    
    func changeScoreLabel() {
        var score = String(userScore!)
        scoreLabel.text = ("Score: \(score)")
    }
    
    
    
    func getJSONData(questionNumber: Int){
        
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        // create a data task
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let result = data{
                
                print("inside get JSON")
                print(result)
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    DispatchQueue.main.async(execute: {
                    
                    
                    if let dictionary = json as? [String:Any]{
                        let numberOfQuestions = dictionary["numberOfQuestions"] as! Int
                        self.numberOfQuestions = numberOfQuestions
                        if let allQuestion = dictionary["questions"] as? [[String:Any]] {
                         //   for i in 0..<numberOfQuestions {
                            let questionNum = allQuestion[questionNumber]["number"] as! Int
                            self.questionNumberLabel.text = ("Question:\(questionNum)/\(numberOfQuestions)")
                            let questionSentence = allQuestion[questionNumber]["questionSentence"] as! String
                            self.questionText.text = questionSentence
                            if let answers = allQuestion[questionNumber]["options"] as? [String:Any] {
                                let AnsA = answers["A"] as! String
                                let AnsB = answers["B"] as! String
                                let AnsC = answers["C"] as! String
                                let AnsD = answers["D"] as! String
                                self.buttonA.setTitle(AnsA, for: .normal)
                                self.buttonB.setTitle(AnsB, for: .normal)
                                self.buttonC.setTitle(AnsC, for: .normal)
                                self.buttonD.setTitle(AnsD, for: .normal)
                         //       }
                                self.correctAnswer = allQuestion[questionNumber]["correctOption"] as! String
                                
                            }
                        }
                    let topic = dictionary["topic"] as! String
                        print(topic)
                    }
                })
                }
                catch{
                    print("Error")
                }
            }
        })
        
        // always call resume() to start
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
    }
    
    @objc func updateDeviceMotion(){
        
        if let data = motionManager.deviceMotion {
            let attitude = data.attitude
            let userAcceleration = data.userAcceleration
            
            if (attitude.roll > 1.0){
                if(buttonA.backgroundColor == UIColor.red){
                    buttonA.backgroundColor = UIColor.lightGray
                    buttonBClicked(buttonB)
                }
                
                if(buttonC.backgroundColor == UIColor.red){
                    buttonC.backgroundColor = UIColor.lightGray
                    buttonDClicked(buttonD)
                }
            }
            
            if(attitude.roll < -1.0){
                if(buttonB.backgroundColor == UIColor.red){
                    buttonB.backgroundColor = UIColor.lightGray
                    buttonAClicked(buttonA)
                }
                
                if(buttonD.backgroundColor == UIColor.red){
                    buttonD.backgroundColor = UIColor.lightGray
                    buttonCClicked(buttonC)
                }
            }
          
            if(attitude.pitch > 1.0){
                if(buttonA.backgroundColor == UIColor.red){
                    buttonA.backgroundColor = UIColor.lightGray
                    buttonCClicked(buttonC)
                }
                
                if(buttonB.backgroundColor == UIColor.red){
                    buttonB.backgroundColor = UIColor.lightGray
                    buttonDClicked(buttonD)
                }
            }
            
            if(attitude.pitch < -1.0){
                if(buttonC.backgroundColor == UIColor.red){
                    buttonC.backgroundColor = UIColor.lightGray
                    buttonAClicked(buttonA)
                }
                
                if(buttonD.backgroundColor == UIColor.red){
                    buttonD.backgroundColor = UIColor.lightGray
                    buttonBClicked(buttonB)
                }
            }
            
            if(attitude.yaw > 1.0 || attitude.yaw < -1.0){
                if(buttonA.backgroundColor == UIColor.red){
                    buttonA.backgroundColor = UIColor.green
                    doubleClick = true
                    
                }
                
                if(buttonB.backgroundColor == UIColor.red){
                    buttonB.backgroundColor = UIColor.green
                    doubleClick = true
                    
                }
                
                if(buttonC.backgroundColor == UIColor.red){
                    buttonC.backgroundColor = UIColor.green
                    doubleClick = true
                  
                }
                
                if(buttonD.backgroundColor == UIColor.red){
                    buttonD.backgroundColor = UIColor.green
                    doubleClick = true
                   
                }
            }
           
            if(userAcceleration.z < -1.0){
                if(buttonA.backgroundColor == UIColor.red){
                    buttonA.backgroundColor = UIColor.green
                    doubleClick = true
                  
                }
                
                if(buttonB.backgroundColor == UIColor.red){
                    buttonB.backgroundColor = UIColor.green
                    doubleClick = true
                    
                }
                
                if(buttonC.backgroundColor == UIColor.red){
                    buttonC.backgroundColor = UIColor.green
                    doubleClick = true
                    
                }
                
                if(buttonD.backgroundColor == UIColor.red){
                    buttonD.backgroundColor = UIColor.green
                    doubleClick = true
                    
                }
            }
        }
    }
    
    //Randomly choose answer when shake
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            var choose = Int(arc4random_uniform(UInt32(3)))
        
            switch choose{
                case 0:
                    buttonAClicked(buttonA)
                
                case 1:
                    buttonBClicked(buttonB)
                
                case 2:
                    buttonCClicked(buttonC)
                
                default:
                    buttonDClicked(buttonD)
            }
        }
    }
    
    @IBAction func buttonAClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
    }
    
    @IBAction func buttonBClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
    }
    
    @IBAction func buttonCClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
    }
    
    @IBAction func buttonDClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
    }
    
    func buttonLogic(sender: UIButton) {
        if !doubleClick {
            if sender.backgroundColor == UIColor.red {
                doubleClick = true
                sender.backgroundColor = UIColor.green
            } else {
                clearButtons()
                sender.backgroundColor = UIColor.red
            }
        }
    }
    
    func checkAnswer() {
        var userAnswer = ""
        switch UIColor.green {
        case buttonA.backgroundColor!:
            userAnswer = "A"
        case buttonB.backgroundColor!:
            userAnswer = "B"
        case buttonC.backgroundColor!:
            userAnswer = "C"
        case buttonD.backgroundColor!:
            userAnswer = "D"
        default:
            userAnswer = ""
        }
        if userAnswer == correctAnswer {
            userScore! += 1
            changeScoreLabel()
        }
    }
    
    func clearButtons() {
        buttonA.backgroundColor = UIColor.lightGray
        buttonB.backgroundColor = UIColor.lightGray
        buttonC.backgroundColor = UIColor.lightGray
        buttonD.backgroundColor = UIColor.lightGray
    }
    
    
    @IBAction func restartGameClicked(_ sender: UIButton) {
        initializeValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
