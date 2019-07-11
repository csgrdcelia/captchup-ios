import UIKit
import Alamofire

class StatsViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var solvedLevelsLabel: UILabel!
    @IBOutlet weak var goodAnswersLabel: UILabel!
    @IBOutlet weak var sentAnswersLabel: UILabel!
    @IBOutlet weak var createdLevelsLabel: UILabel!
    
    var userSolvedLevels: Int?
    var userGoodAnswers: Double?
    var userSentAnswers: Int?
    var userCreatedLevels: Int?
    
    var globalSolvedLevels: Int?
    var globalGoodAnswers: Double?
    var globalSentAnswers: Int?
    var globalCreatedLevels: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(segmentedControl.selectedSegmentIndex == 0) {
            displayUserStats()
        } else {
            displayGlobalStats()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userSolvedLevels = nil
        userGoodAnswers = nil
        userSentAnswers = nil
        userCreatedLevels = nil
        globalSolvedLevels = nil
        globalGoodAnswers = nil
        globalSentAnswers = nil
        globalCreatedLevels = nil
        viewDidLoad()
    }
    
    @IBAction func segmentedControl_ValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: displayUserStats()
        case 1: displayGlobalStats()
        default: break;
        }
    }
    
    
    func callUserStats() {
        getNumberOfSolvedLevels(userOnly: true)
        getGoodAnswersRate(userOnly: true)
        getNumberOfSentAnswers(userOnly: true)
        getNumberOfCreatedLevels(userOnly: true)
        getNumberOfSolvedLevels(userOnly: false)
        getGoodAnswersRate(userOnly: false)
        getNumberOfSentAnswers(userOnly: false)
        getNumberOfCreatedLevels(userOnly: false)
    }
    
    
    func displayUserStats() {
        guard userSolvedLevels != nil else {
            print("userSolvedLevels null")
            getNumberOfSolvedLevels(userOnly: true)
            return
        }
        guard userGoodAnswers != nil else {
            print("userGoodAnswers null")
            getGoodAnswersRate(userOnly: true)
            return
        }
        guard userSentAnswers != nil else {
            print("userSentAnswers null")
            getNumberOfSentAnswers(userOnly: true)
            return;
        }
        guard userCreatedLevels != nil else {
            print("userCreatedLevels null")
            getNumberOfCreatedLevels(userOnly: true)
            return;
        }
        print("finally displaying user values")
        solvedLevelsLabel.text = String(userSolvedLevels!)
        goodAnswersLabel.text = (String(format:"%.1f",userGoodAnswers! * 100) + "%")
        sentAnswersLabel.text = String(userSentAnswers!)
        createdLevelsLabel.text = String(userCreatedLevels!)
    }
    
    func displayGlobalStats() {
        guard globalSolvedLevels != nil else {
            print("globalSolvedLevels null")
            getNumberOfSolvedLevels(userOnly: false)
            return
        }
        guard globalGoodAnswers != nil else {
            print("globalGoodAnswers null")
            getGoodAnswersRate(userOnly: false)
            return
        }
        guard globalSentAnswers != nil else {
            print("globalSentAnswers null")
            getNumberOfSentAnswers(userOnly: false)
            return;
        }
        guard globalCreatedLevels != nil else {
            print("globalCreatedLevels null")
            getNumberOfCreatedLevels(userOnly: false)
            return;
        }
        print("finally displaying global values")
        solvedLevelsLabel.text = String(globalSolvedLevels!)
        goodAnswersLabel.text = (String(format: "%.1f", globalGoodAnswers! * 100) + "%")
        sentAnswersLabel.text = String(globalSentAnswers!)
        createdLevelsLabel.text = String(globalCreatedLevels!)
    }
    
    func getNumberOfSolvedLevels(userOnly: Bool) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!
        ]
        let url = userOnly ? ApiManager.apiUrl + "statistic/getNumberOfSolvedLevelsByUser" : ApiManager.apiUrl + "statistic/numberOfSolvedLevels"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                case.success:
                    print("numbers of solved levels call : success. userOnly" + String(userOnly))
                    guard let data = response.result.value else { return }
                    if(userOnly) {
                        self.userSolvedLevels = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayUserStats()
                    } else {
                        self.globalSolvedLevels = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayGlobalStats()
                    }
                case .failure(let error):
                    print("error while loading solved levels. userOnly: " + String(userOnly))
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func getGoodAnswersRate(userOnly: Bool) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!
        ]
        let url = ApiManager.apiUrl + "statistic/goodAnswersRate" + (userOnly ? "ByUser" : "")
        Alamofire.request(url, method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                case.success:
                    print("rate of good answers call : success. userOnly" + String(userOnly))
                    guard let data = response.result.value else { return }
                    if(userOnly) {
                        self.userGoodAnswers = (data == "\"NaN\"" ? 0 : Double(data))
                        self.displayUserStats()
                    } else {
                        self.globalGoodAnswers = (data == "\"NaN\"" ? 0 : Double(data))
                        self.displayGlobalStats()
                    }
                case .failure(let error):
                    print("error while loading good answers rate. userOnly: " + String(userOnly))
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func getNumberOfSentAnswers(userOnly: Bool) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!
        ]
        let url = ApiManager.apiUrl + "statistic/numberOfLevelAnswer" + (userOnly ? "ByUser" : "")
        Alamofire.request(url, method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                case.success:
                    print("numbers of sent answers call : success. userOnly" + String(userOnly))
                    guard let data = response.result.value else { return }
                    if(userOnly) {
                        self.userSentAnswers = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayUserStats()
                    } else {
                        self.globalSentAnswers = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayGlobalStats()
                    }
                case .failure(let error):
                    print("error while loading number of answers. userOnly: " + String(userOnly))
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func getNumberOfCreatedLevels(userOnly: Bool) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!
        ]
        let url = ApiManager.apiUrl + "statistic/numberOfCreatedLevels" + (userOnly ? "ByUser" : "")
        Alamofire.request(url, method: .get, parameters: nil,  headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                case.success:
                    print("numbers of created levels call : success. userOnly" + String(userOnly))
                    guard let data = response.result.value else { return }
                    if(userOnly) {
                        self.userCreatedLevels = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayUserStats()
                    } else {
                        self.globalCreatedLevels = (data == "\"NaN\"" ? 0 : Int(data))
                        self.displayGlobalStats()
                    }
                case .failure(let error):
                    print("error while loading number of created levels. userOnly: " + String(userOnly))
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }

}
