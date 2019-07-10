//
//  GameViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 23/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import UIKit
import Alamofire

class GameViewController: UIViewController {

    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstPredictionTextView: UILabel!
    @IBOutlet weak var secondPredictionTextView: UILabel!
    @IBOutlet weak var thirdPredictionTextViex: UILabel!
    
    
    var level: Level?
    var solvedPredictions: [Prediction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard level != nil else { return }
        imageView.imageFromUrl(urlString: level!.image)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        getSolvedPredictions()
        
    }
    
    
    @IBAction func answerTextFieldOnExit(_ sender: Any) {
        sendAnswer(answer: answerTextField.text!)
    }
    
    func updatePredictionsOnView() {
        if solvedPredictions.contains((level?.levelPredictions[0].prediction)!) {
            firstPredictionTextView.text = (level?.levelPredictions[0].prediction)?.word
        } else {
            firstPredictionTextView.text = "?"
        }
        if solvedPredictions.contains((level?.levelPredictions[1].prediction)!) {
            secondPredictionTextView.text = (level?.levelPredictions[1].prediction)?.word
        } else {
            secondPredictionTextView.text = "?"
        }
        if solvedPredictions.contains((level?.levelPredictions[2].prediction)!) {
            thirdPredictionTextViex.text = (level?.levelPredictions[2].prediction)?.word
        } else {
            thirdPredictionTextViex.text = "?"
        }
    }
    
    func getSolvedPredictions() {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!,
            "Accept": "application/json"
        ]
        let url = ApiManager.apiUrl + "level/\(level!.id)/predictions/solved"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case.success:
                    do {
                        guard let data = response.data else { return }
                        self.solvedPredictions = try JSONDecoder().decode([Prediction].self, from: data)
                        if(self.solvedPredictions.count == 3) {
                            self.answerTextField.isHidden = true
                        }
                    } catch {
                        return
                    }
                    self.updatePredictionsOnView()
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func sendAnswer(answer: String) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let url = ApiManager.apiUrl + "level/\(level!.id)/solve"
        Alamofire.request(url, method: .post, parameters: ["answer": answer], encoding: URLEncoding.httpBody, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case.success:
                    var levelAnswer: LevelAnswer
                    do {
                        guard let data = response.data else { return }
                        levelAnswer = try JSONDecoder().decode(LevelAnswer.self, from: data)
                    } catch {
                        return
                    }
                    self.processAnswerResult(prediction: levelAnswer.prediction)
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
        answerTextField.text = ""
    }
    
    func processAnswerResult(prediction: Prediction?) {
        guard prediction != nil else {
            //TODO: tell user he has not solved any prediction
            return
        }
        guard !solvedPredictions.contains(prediction!) else {
            //TODO: tell user he has already solved this prediction
            return
        }
        solvedPredictions.append(prediction!)
        self.updatePredictionsOnView()
    }
    
    

}
