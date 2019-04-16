//
//  DetailViewController.swift
//  DeckOfCards1
//
//  Created by Marcus Vinicius Vieira Badiale on 16/04/19.
//  Copyright © 2019 Annderson Packeiser Oreto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var card: Card! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: card.image)
        let data = try? Data(contentsOf: url!)
        self.detailImage.image = UIImage(data: data!)
        detailLabel.text = card.suit + " " + card.value
    } 
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBAction func backButton(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

}
