//
//  GameViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/19/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController, MCSessionDelegate {
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    
    
    @IBOutlet var arrayOfUserChoices: [UILabel]!
    
    
    @IBOutlet var arrayOfUserScores: [UILabel]!
    
//    @IBOutlet weak var user1ChoiceLabel: UILabel!
//    @IBOutlet weak var user1ScoreLabel: UILabel!
//    @IBOutlet weak var user2ChoiceLabel: UILabel!
//    @IBOutlet weak var user2ScoreLabel: UILabel!
//    @IBOutlet weak var user3ChoiceLabel: UILabel!
//    @IBOutlet weak var user3ScoreLabel: UILabel!
//    @IBOutlet weak var user4ChoiceLabel: UILabel!
//    @IBOutlet weak var user4ScoreLabel: UILabel!
//
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var session: MCSession!
    var peerID: MCPeerID!
    var doubleClick: Bool!
    var userScore: Int!
    var correctAnswer: String!
   // var userAnswer: String!
    

    @IBOutlet var arrayOfImages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeValues()
        
        // Do any additional setup after loading the view.
        
    }
    
    func initializeValues() {
        restartButton.isHidden = true
        winLabel.isHidden = true
        doubleClick = false
        userScore = 0
        correctAnswer = "A"
        setUpPlayersImages()
        
    }
    
    
    
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
     //   checkForUserChoice()
    }
    
    @IBAction func buttonBClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
    //    checkForUserChoice()
    }
    
    @IBAction func buttonCClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
     //   checkForUserChoice()
    }
    
    @IBAction func buttonDClicked(_ sender: UIButton) {
        buttonLogic(sender: sender)
       // checkForUserChoice()
    }
    
    func buttonLogic(sender: UIButton) {
        if !doubleClick {
            if sender.backgroundColor == UIColor.red {
                doubleClick = true
                sender.backgroundColor = UIColor.green
                checkForUserChoice()
                addScore()
            } else {
                clearButtons()
                sender.backgroundColor = UIColor.red
            }
        }
    }
    
    func checkForUserChoice() {
        var userAnswer = ""
        switch UIColor.green {
        case buttonA.backgroundColor:
            userAnswer = "A"
            setAndSendAnswer(answer: userAnswer)
        case buttonB.backgroundColor:
            userAnswer = "B"
            setAndSendAnswer(answer: userAnswer)
        case buttonC.backgroundColor:
            userAnswer = "C"
            setAndSendAnswer(answer: userAnswer)
        case buttonD.backgroundColor:
            userAnswer = "D"
            setAndSendAnswer(answer: userAnswer)
        default:
            userAnswer = "..."
            setAndSendAnswer(answer: userAnswer)
        }
//        if userAnswer == correctAnswer {
//            userScore! += 1
//
//         //   changeScoreLabel()
//        }
    }
    
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
        
        
//        for i in 0..<session.connectedPeers.count +1 {
//            if arrayOfUserChoices[i].text! == correctAnswer {
//                arrayOfUserScores[i].text ==
//            }
//        }
    }
    
    func setAndSendAnswer(answer: String) {
        arrayOfUserChoices[0].text = answer
        showUserAnswer(ans: answer)
    }
    
    func showUserAnswer(ans: String) {
        let notifyUsersOfAnswer = NSKeyedArchiver.archivedData(withRootObject: ans)
        do {
            try session.send(notifyUsersOfAnswer, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print ("Error in sending data \(err)")
        }
//        for i in 0..<session.connectedPeers.count {
//            if session.connectedPeers[i] == peer {
//                arrayOfUserChoices[i].text = ans
//            }
//        }
    }
    
    func clearButtons() {
        buttonA.backgroundColor = UIColor.lightGray
        buttonB.backgroundColor = UIColor.lightGray
        buttonC.backgroundColor = UIColor.lightGray
        buttonD.backgroundColor = UIColor.lightGray
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
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("inside didReceiveData")
        
        // this needs to be run on the main thread
        print(session.connectedPeers.count)
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                for i in 0..<session.connectedPeers.count {
                    if session.connectedPeers[i] == peerID {
                        self.arrayOfUserChoices[i+1].text = receivedString
                    }
                }
            }
            
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
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? ViewController {
//            destination.session = self.session
//            destination.peerID = self.peerID
//            session.delegate = destination
//        }
//    }
    
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
