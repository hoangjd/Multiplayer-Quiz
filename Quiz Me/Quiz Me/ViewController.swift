//
//  ViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/19/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var gameTypeSegmentedButton: UISegmentedControl!
    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var connectedPeers: [MCPeerID]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "gaming", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "gaming", discoveryInfo: nil, session: session)
        connectedPeers = [MCPeerID]()
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func connectToUsers(_ sender: UIBarButtonItem) {
         present(browser, animated: true, completion: nil)
    }
    
    @IBAction func startGameClicked(_ sender: UIButton) {
        if gameTypeSegmentedButton.selectedSegmentIndex == 0 {
            if connectedPeers.count == 0 {
                performSegue(withIdentifier: "ToGame", sender: self)
            }
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            connectedPeers.append(peerID)
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
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


}

