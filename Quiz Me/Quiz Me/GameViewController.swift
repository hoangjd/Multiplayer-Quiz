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
    
    var session: MCSession!
    var peerID: MCPeerID!
    

    @IBOutlet var ArrayOfImageViews: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(session.connectedPeers.count)
        setUpPlayersImages()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    func setUpPlayersImages() {
        for i in 1..<ArrayOfImageViews.count {
            ArrayOfImageViews[i].isHidden = true
        }
        for i in 1...session.connectedPeers.count {
            ArrayOfImageViews[i].isHidden = false
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
