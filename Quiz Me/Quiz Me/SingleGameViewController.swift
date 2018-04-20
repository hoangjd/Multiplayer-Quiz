//
//  SingleGameViewController.swift
//  Quiz Me
//
//  Created by Joseph Hoang on 4/20/18.
//  Copyright © 2018 Joe Hoang. All rights reserved.
//

import UIKit

class SingleGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONData()
        // Do any additional setup after loading the view.
    }
    
    func getJSONData(){
        
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
                        print(dictionary["numberOfQuestions"])
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
