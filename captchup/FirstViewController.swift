//
//  FirstViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 01/05/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var levels: [Level] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLevels()
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! LevelTableViewCell
        cell.levelImageView.imageFromUrl(urlString: levels[indexPath.row].image)
        cell.levelImageView.contentMode = UIView.ContentMode.scaleAspectFill
        cell.levelImageView.clipsToBounds = true
        return cell
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
                    self.tableView.reloadData()
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Alert " + ApiManager.token!, style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
}

