import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonClick(_ sender: Any) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please fill the username and password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let parameters: Parameters = [ "username": usernameTextField.text ?? "", "password" : passwordTextField.text ?? "" ]
            Alamofire.request(ApiManager.apiUrl + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseData { response in switch response.result {
                case .success(_):
                    ApiManager.token = response.response?.allHeaderFields["Authorization"] as! String?
                    do {
                        guard let data = response.data else { return }
                        ApiManager.user = try JSONDecoder().decode(User.self, from: data)
                    } catch {
                        print("Can't retrieve user info")
                    }
                    self.performSegue(withIdentifier: "showTabBar", sender: nil)
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
