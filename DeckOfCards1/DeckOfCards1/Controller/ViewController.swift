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
    var count: Int = 0
    var counter: Int = 0
    var gameTimer: Timer!
    var playerRedPoints: Int = 0
    var playerBluePoints: Int = 0
    var pile: Int = 0
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var buttonBlue: UIButton!
    @IBOutlet weak var buttonRed: UIButton!
    @IBOutlet weak var counterRed: UILabel!
    @IBOutlet weak var pointsRed: UILabel!
    @IBOutlet weak var counterBlue: UILabel!
    @IBOutlet weak var pointsBlue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonRed.transform = CGAffineTransform(rotationAngle: .pi)
        counterRed.transform = CGAffineTransform(rotationAngle: .pi)
        pointsRed.transform = CGAffineTransform(rotationAngle: .pi)
        counterRed.text = self.counter.description
        counterBlue.text = self.counter.description
        pointsRed.text = self.playerRedPoints.description
        pointsBlue.text = self.playerBluePoints.description
        createDeck()
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(action1), userInfo: nil, repeats: true)
    }
    
    @objc func action1() {
        remaining -= 1
        if remaining <= 1 {
            gameTimer.invalidate()
        }
        drawCard()
        
        let url = URL(string: hand[count].image)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.counterRed.text = self.counter.description
                self.counterBlue.text = self.counter.description
                self.imageButton.setImage(UIImage(data: data!), for: .normal)
            }
        
        count += 1
        pile += 1
        if counter >= 13 {
            counter = 0
        }
        counter += 1
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
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            task.resume()
        }
        
    }
    @IBAction func blueButton(_ sender: UIButton) {
        var aux: Int = 0
        switch hand[count-1].value {
        case "ACE":
            aux = 1
        case "JACK":
            aux = 11
        case "QUEEN":
            aux = 12
        case "KING":
            aux = 13
        default:
            aux = Int(hand[count-1].value)!
        }
        if counter == aux {
            playerBluePoints += pile
            pile = 0
            pointsBlue.text = self.playerBluePoints.description
        }
    }
    
    @IBAction func redButton(_ sender: UIButton) {
        var aux: Int = 0
        switch hand[count-1].value {
        case "ACE":
            aux = 1
        case "JACK":
            aux = 11
        case "QUEEN":
            aux = 12
        case "KING":
            aux = 13
        default:
            aux = Int(hand[count-1].value)!
        }
        if counter == aux {
            playerRedPoints += pile
            pile = 0
            pointsRed.text = self.playerRedPoints.description
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let card1 = hand[count-1]
        performSegue(withIdentifier: "info", sender: card1)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "info":
            let dest : DetailViewController = segue.destination as! DetailViewController
            dest.card = sender as? Card
        default:
            break
        }
    }

}



