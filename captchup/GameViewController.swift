import UIKit
import Alamofire

class GameViewController: UIViewController {

    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstPredictionTextView: UILabel!
    @IBOutlet weak var secondPredictionTextView: UILabel!
    @IBOutlet weak var thirdPredictionTextView: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var triesOnAverageLabel: UILabel!
    
    var level: Level?
    var solvedPredictions: [Prediction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard level != nil else { return }
        imageView.imageFromUrl(urlString: level!.image)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        creatorLabel.text = level?.creator.username
        getSolvedPredictions()
        getAverageNumberOfAnswers()
    }
    
    
    @IBAction func answerTextFieldOnExit(_ sender: Any) {
        sendAnswer(answer: answerTextField.text!)
    }
    
    func updatePredictionsOnView() {
        if solvedPredictions.contains((level?.levelPredictions[0].prediction)!) {
            firstPredictionTextView.text = (level?.levelPredictions[0].prediction)?.word
        } else {
            firstPredictionTextView.text = String(format: "%.1f", level!.levelPredictions[0].pertinence * 100) + "%"
        }
        if solvedPredictions.contains((level?.levelPredictions[1].prediction)!) {
            secondPredictionTextView.text = (level?.levelPredictions[1].prediction)?.word
        } else {
            secondPredictionTextView.text = String(format: "%.1f", level!.levelPredictions[1].pertinence * 100) + "%"
        }
        if solvedPredictions.contains((level?.levelPredictions[2].prediction)!) {
            thirdPredictionTextView.text = (level?.levelPredictions[2].prediction)?.word
        } else {
            thirdPredictionTextView.text = String(format: "%.1f", level!.levelPredictions[2].pertinence * 100) + "%"
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
            self.showToast(controller: self, message: "Try again!", seconds: 1)
            return
        }
        guard !solvedPredictions.contains(prediction!) else {
            self.showToast(controller: self, message: "Already found!", seconds: 1)
            return
        }
        self.showToast(controller: self, message: "Correct!", seconds: 1)
        solvedPredictions.append(prediction!)
        if(solvedPredictions.count == 3) {
            answerTextField.isHidden = true
        }
        self.updatePredictionsOnView()
    }
    
    func getAverageNumberOfAnswers() {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!
        ]
        let url = ApiManager.apiUrl + "statistic/averageNumberOfAnswersPerCompletedLevels/" + String(level!.id)
        Alamofire.request(url, method: .get, parameters: nil,  headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                case.success:
                    guard let data = response.result.value else { return }
                    if data.isEmpty {
                        self.triesOnAverageLabel.text = "level never finished!"
                    } else {
                        self.triesOnAverageLabel.text = data + " tries on average"
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}
