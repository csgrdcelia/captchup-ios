//
//  GameViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 23/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var level: Level?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard level != nil else {
            return
        }
        imageView.imageFromUrl(urlString: level!.image)
    }
    
    
    @IBAction func answerTextFieldOnExit(_ sender: Any) {
        label.text = "sent"
    }
    

 

}
