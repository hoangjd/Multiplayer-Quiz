//
//  GameViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/19/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController, MCSessionDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet var arrayOfUserChoices: [UILabel]!
    @IBOutlet var arrayOfUserScores: [UILabel]!
    
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var session: MCSession!
    var peerID: MCPeerID!
    var doubleClick: Bool!
    var userScore: Int!
    var correctAnswer: String!
   // var userAnswer: String!
    var numberOfQuestions: Int!
    var timeToNextQuestion: Int!
    var questionSearchCount: Int!
    

    @IBOutlet var arrayOfImages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeValues()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    //initialize all of our globals and sets base environment
    func initializeValues() {
        restartButton.isHidden = true
        winLabel.isHidden = true
        doubleClick = false
        userScore = 0
        correctAnswer = "A"
        numberOfQuestions = -2
        timeToNextQuestion = 0
        questionSearchCount = 0
        initializeScores()
        setUpPlayersImages()
        startTimer()
        changeTimeLabel()
        
    }
    
    
    // this hides unused images and unhides used images based on amt of players
    func setUpPlayersImages() {
        for i in 1..<arrayOfImages.count {
            arrayOfImages[i].isHidden = true
            arrayOfUserChoices[i].isHidden = true
            arrayOfUserScores[i].isHidden = true
        }
        for i in 1...session.connectedPeers.count {
            arrayOfImages[i].isHidden = false
            arrayOfUserChoices[i].isHidden = false
            arrayOfUserScores[i].isHidden = false
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
    
    //logic for choosing answer
    func buttonLogic(sender: UIButton) {
        if !doubleClick {
            if sender.backgroundColor == UIColor.red {
                doubleClick = true
                sender.backgroundColor = UIColor.green
                checkForUserChoice()
            } else {
                clearButtons()
                sender.backgroundColor = UIColor.red
            }
        }
    }
    
    //decides what choice you made
    func checkForUserChoice() {
        var userAnswer = ""
        switch UIColor.green {
        case buttonA.backgroundColor!:
            userAnswer = "A"
            setAndSendAnswer(answer: userAnswer)
        case buttonB.backgroundColor!:
            userAnswer = "B"
            setAndSendAnswer(answer: userAnswer)
        case buttonC.backgroundColor!:
            userAnswer = "C"
            setAndSendAnswer(answer: userAnswer)
        case buttonD.backgroundColor!:
            userAnswer = "D"
            setAndSendAnswer(answer: userAnswer)
        default:
            userAnswer = "..."
            setAndSendAnswer(answer: userAnswer)
        }

    }
    
    //this checks your answer with the correct answer and updates your score
    func addScore() {
        let mychoice = arrayOfUserChoices[0].text!
        if mychoice == correctAnswer {
            userScore! += 1
            arrayOfUserScores[0].text = String("\(userScore!)")
        }
        
        let notifyUsersOfScore = NSKeyedArchiver.archivedData(withRootObject: userScore!)
        do {
            try session.send(notifyUsersOfScore, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print ("Error in sending Score \(err)")
        }
        
    }
    
    //sets your answer on your device and calls send answer
    func setAndSendAnswer(answer: String) {
        arrayOfUserChoices[0].text = answer
        showUserAnswer(ans: answer)
    }
    
    //send user answer to other players
    func showUserAnswer(ans: String) {
        let notifyUsersOfAnswer = NSKeyedArchiver.archivedData(withRootObject: ans)
        do {
            try session.send(notifyUsersOfAnswer, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print ("Error in sending data \(err)")
        }

    }
    
    func clearButtons() {
        buttonA.backgroundColor = UIColor.lightGray
        buttonB.backgroundColor = UIColor.lightGray
        buttonC.backgroundColor = UIColor.lightGray
        buttonD.backgroundColor = UIColor.lightGray
    }
    
    //set all active users score labels to 0
    func initializeScores(){
        arrayOfUserScores[0].text = String(userScore!)
        for i in 0..<session.connectedPeers.count {
            arrayOfUserScores[i+1].text = "0"
        }
    }
    
    //set all active users answer lables to ...
    func initializeAnswerLabels(){
        arrayOfUserChoices[0].text = "..."
        for i in 0..<session.connectedPeers.count {
            arrayOfUserChoices[i+1].text = "..."
        }
    }
    
    
    
    //this is called every 20 seconds to update questions from json response
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
                                let questionNum = allQuestion[questionNumber]["number"] as! Int
                                self.questionNumLabel.text = ("Question:\(questionNum)/\(numberOfQuestions)")
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
    
    func checkIfUserWon() {
        for i in 0..<session.connectedPeers.count {
            if Int(arrayOfUserScores[0].text!)! >= Int(arrayOfUserScores[i+1].text!)! {
                winLabel.text = "YOU WIN!"
                return
            }
        }
        winLabel.text = "YOU LOSE"
    }
    
    
    func startTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTime)), userInfo: nil, repeats: true)
    }
    
    func changeTimeLabel() {
        var time = String(20 - timeToNextQuestion)
        timeLabel.text = ("Time Left: \(time)")
    }
    
    @objc func updateTime(_ sender: Timer) {
        timeToNextQuestion! += 1
        //lastquestion
        if (questionSearchCount > (numberOfQuestions) && questionSearchCount != 0) {
            restartButton.isHidden = false
            winLabel.isHidden = false
            checkIfUserWon()
            sender.invalidate()
        } else { //firstquestion
            changeTimeLabel()
            if questionSearchCount == 0 && timeToNextQuestion == 1{
                getJSONData(questionNumber: questionSearchCount)
                questionSearchCount! += 1
            }
            //middle questions
            if timeToNextQuestion%20 == 0 {
                addScore()
                initializeAnswerLabels()
                clearButtons()
                doubleClick = false
                timeToNextQuestion = 0
                if questionSearchCount != 4 {
                    getJSONData(questionNumber: questionSearchCount)
                }
                questionSearchCount! += 1
            }
        }
    }
    
    @IBAction func restartButtonPushed(_ sender: UIButton) {
        let restartFlag = "Restart"
        let restart = NSKeyedArchiver.archivedData(withRootObject: restartFlag)
        do {
            try session.send(restart, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print("Error in Restart\(err)")
        }
        
        initializeValues()
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            //       connectedPeers.append(peerID)
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    //how others recieve data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("inside didReceiveData")
        
        // this needs to be run on the main thread
        print(session.connectedPeers.count)
        DispatchQueue.main.async(execute: {
            //user answer recieved
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                if receivedString == "Restart" {
                    self.initializeValues()
                    return
                }
                for i in 0..<session.connectedPeers.count {
                    if session.connectedPeers[i] == peerID {
                        self.arrayOfUserChoices[i+1].text = receivedString

                    }
                }
            }
            
            //user score recieved
            if let receviedInt = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int{
                for i in 0..<session.connectedPeers.count {
                    if session.connectedPeers[i] == peerID {
                        self.arrayOfUserScores[i+1].text = String(receviedInt)
                    }
                }
            }
        })
            
//            if let image = UIImage(data: data) {
//
//                self.imgView.image = image
//
//                self.updateChatView(newText: "received image", id: peerID)
//
//                //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//
//            }
//
//        })
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    //user disconnect when they leave this view
    override func viewWillDisappear(_ animated: Bool) {
        self.session.disconnect()
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


