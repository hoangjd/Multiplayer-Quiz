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
    

    @IBOutlet var arrayOfImages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeValues()
        
        // Do any additional setup after loading the view.
        
    }
    
    func initializeValues() {
        restartButton.isHidden = true
        winLabel.isHidden = true
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
    

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
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
