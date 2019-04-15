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
    @IBOutlet weak var cardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDeck()
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
                        self.shuffleCards()
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            task.resume()
        }
    }
    
    func shuffleCards(){
        let urlString = URL(string: "https://deckofcardsapi.com/api/deck/\(deckId)/shuffle/")
        
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
                        self.drawCard()
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
        
//        print("https://deckofcardsapi.com/api/deck/<<\(self.deckId)>>/draw/?count=1")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    
                } else {
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        guard let jsonArray = jsonResponse as? [String: Any] else {
                            print("teste1")
                            return
                        }
                        print(jsonArray)
                        //Now get title value
                        guard let title = jsonArray["cards"] as? [[String : Any]] else { return }
                        let title2 = title[0]
                        guard let image = title2["image"] as? String else { return }
                        guard let value = title2["value"] as? String else { return }
                        guard let suit = title2["suit"] as? String else { return }
                        guard let code = title2["code"] as? String else { return }
                        
                        self.hand.append(Card(image: image, value: value, suit: suit, code: code))
                        let url = URL(string: image)
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!)
                            DispatchQueue.main.async {
                                self.cardImage.image = UIImage(data: data!)
                            }
                        }
                        
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


