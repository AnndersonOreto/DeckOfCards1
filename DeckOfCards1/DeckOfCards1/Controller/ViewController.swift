//
//  ViewController.swift
//  DeckOfCards1
//
//  Created by Annderson Packeiser Oreto on 15/04/19.
//  Copyright © 2019 Annderson Packeiser Oreto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var hand: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("😁")
    }
    
    func drawCard() {
        
        let urlString = URL(string: "")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                    }
                }
            }
            task.resume()
        }
        
    }

}


