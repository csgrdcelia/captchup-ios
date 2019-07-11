import UIKit
import Alamofire

class NewImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var uploadLevel: Level?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLevelIsNotUpload()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    @IBAction func pickImageButton_OnClick(_ sender: Any) {
        launchImagePicker()
    }
    
    @IBAction func playButton_OnCick(_ sender: Any) {
        self.performSegue(withIdentifier: "showLevel", sender: uploadLevel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLevel" {
            if let nextViewController = segue.destination as? GameViewController {
                guard let level = sender as? Level else { return }
                nextViewController.level = level
            }
        }
    }
    
    func launchImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            imageView?.contentMode = UIView.ContentMode.scaleAspectFill
            imageView?.image = image
            createLevel(image: image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func createLevel(image: UIImage) {
        let headers: HTTPHeaders = [
            "Authorization": ApiManager.token!,
            "Content-type": "multipart/form-data"
        ]
        let apiUrl: String = ApiManager.apiUrl + "level/create"
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imageData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            
        }, usingThreshold: UInt64.init(), to: apiUrl, method: .post, headers: headers)
        { (result) in
            switch result{
            case .success(let upload, _, _):
                upload
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                    do {
                        guard let data = response.data else { return }
                        self.uploadLevel = try JSONDecoder().decode(Level.self, from: data)
                        self.displayLevelIsUpload()
                    } catch {
                        return
                    }
                    
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Alert " + ApiManager.token!, style: .default)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
    }
    
    func displayLevelIsUpload() {
        pickImageButton.isHidden = true
        playButton.isHidden = false
    }
    
    func displayLevelIsNotUpload() {
        pickImageButton.isHidden = false
        playButton.isHidden = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
