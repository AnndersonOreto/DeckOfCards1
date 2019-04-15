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
    var deckId: String = ""
    var remaining: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        createDeck()
        drawCard()
        print("😁")
    }
    
    func createDeck(){
        let urlString = URL(string: "https://deckofcardsapi.com/api/deck/new/")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                } else {
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        guard let jsonArray = jsonResponse as? [String: Any] else {
                            return
                        }
                        //Now get title value
                        guard let title = jsonArray["deck_id"] as? String else { return }
                        self.deckId = title
                        guard let title2 = jsonArray["remaining"] as? Int else { return }
                        self.remaining = title2
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            task.resume()
        }
    }
    
    func drawCard() {
        
        let urlString = URL(string: "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=1")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    
                } else {
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        guard let jsonArray = jsonResponse as? [String: Any] else {
                            return
                        }
                        //Now get title value
                        guard let title = jsonArray["cards"] as? [JSONSerialization] else { return }
                        guard let title2 = title[0] as? [String : Any] else { return }
                        
                        
                        print(jsonResponse)
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func jsonParser(aux: Data) {
        do{
            //here dataResponse received from a network request
            let jsonResponse = try JSONSerialization.jsonObject(with: aux, options:.allowFragments)
            guard let jsonArray = jsonResponse as? [String: Any] else {
                return
            }
            
        }catch let parsingError {
            print("Error", parsingError)
        }
    }

}


