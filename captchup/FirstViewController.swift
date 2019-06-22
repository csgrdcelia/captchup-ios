//
//  FirstViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 01/05/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    private var levels: [Level] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "truc"
        getLevels()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getLevels() {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!,
            "Accept": "application/json"
        ]
        Alamofire.request(ApiManager.apiUrl + "level/all", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case.success(let data):
                    guard let json = data as? [[String: Any]] else {
                        return
                    }
                    self.levels.append(contentsOf: json.compactMap({
                        guard let level = Level.from(json: $0) else {
                            return nil
                        }
                        return level
                    }))
                    self.label.text = self.levels.description
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Alert " + ApiManager.token!, style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
}

