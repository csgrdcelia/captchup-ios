//
//  LoginViewController.swift
//  captchup
//
//  Created by Celia Casagrande on 19/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

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
                    let alert = UIAlertController(title: "Alert", message: "token : " + ApiManager.token!, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    /*self.performSegue(withIdentifier: "showLoginView", sender: nil)*/
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
