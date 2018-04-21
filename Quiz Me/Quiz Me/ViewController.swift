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
  //  var connectedPeers: [MCPeerID]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVals()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initializeVals() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "gaming", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "gaming", discoveryInfo: nil, session: session)
        //   connectedPeers = [MCPeerID]()
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
    }
    
    @IBAction func connectToUsers(_ sender: UIBarButtonItem) {
  //      initializeVals()
         present(browser, animated: true, completion: nil)
    }
    
    @IBAction func startGameClicked(_ sender: UIButton) {
        let notifyChangeMessage = "Move"
        let notifyChange = NSKeyedArchiver.archivedData(withRootObject: notifyChangeMessage)
        if gameTypeSegmentedButton.selectedSegmentIndex == 0 {
            if session.connectedPeers.count == 0 {
                performSegue(withIdentifier: "ToGameSingle", sender: self)
            } else  {
                alertMessage(problem: "Cannot Play Solo While Connected to Peers")
            }
        }
        if gameTypeSegmentedButton.selectedSegmentIndex == 1 {
            if session.connectedPeers.count > 3 {
                 alertMessage(problem: "Cannot Play Multiplayer With More Than 4 Peeps")
            } else if session.connectedPeers.count == 0 {
                alertMessage(problem: "Cannot Play Multiplayer Without Any Connections")
            } else {
                sendViewControllerChange(dataToSend: notifyChange)
                performSegue(withIdentifier: "ToGame", sender: self)
            }
        }
    }
    
    func sendViewControllerChange(dataToSend: Data) {
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
    }
    
    func alertMessage(problem: String) {
        var alert = UIAlertController(title: "Error", message: problem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
     //       connectedPeers.append(peerID)
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let recievedMessage = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                if recievedMessage == "Move" {
                    self.performSegue(withIdentifier: "ToGame", sender: self)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.session = self.session
            destination.peerID = self.peerID
            session.delegate = destination
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.session.connectedPeers.count == 0 {
            initializeVals()
        }
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

