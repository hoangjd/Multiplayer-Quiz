//
//  SingleGameViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/20/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit

class SingleGameViewController: UIViewController {
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var numberOfQuestions: Int!
    var timeToNextQuestion = 0
    var moveToNextQuestion = false
    var correctAnswer: String!
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        getNumberOfQuestions()
        changeTimeLabel()
        startTimer()
       // developQuestion()
//        getJSONData(questionNumber: 0)

       // getNumberOfQuestions()
    //    developQuestion()
        // Do any additional setup after loading the view.
    }
    
    func startTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTime)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(_ sender: Timer) {
        timeToNextQuestion += 1
        changeTimeLabel()
        if count == 4 {
            sender.invalidate()
        }
        
        if count == 0 && timeToNextQuestion == 1{
//            moveToNextQuestion = false
//            var playerHasAnswered = false
            getJSONData(questionNumber: count)
            count += 1
        }
        
        if timeToNextQuestion%20 == 0 {
            timeToNextQuestion = 0
            getJSONData(questionNumber: count)
            count += 1
        }
    }
    func changeTimeLabel() {
        var time = String(20 - timeToNextQuestion)
        timeLabel.text = ("Time Left: \(time)")
    }
    
    func getNumberOfQuestions() {
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
                    
                    if let dictionary = json as? [String:Any]{
                        self.numberOfQuestions = dictionary["numberOfQuestions"] as! Int

                    }
                }
                catch{
                    print("Error")
                }
            }
            })
            // always call resume() to start
            task.resume()
            
    }
    
//    func developQuestion(){
//
//     //   for i in 0..<numberOfQuestions {
//        for i in 0..<4 {
//            moveToNextQuestion = false
//            var playerHasAnswered = false
//            getJSONData(questionNumber: i)
////            while (!moveToNextQuestion || !playerHasAnswered) {
////
////            }
//        }
//    }
    
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
