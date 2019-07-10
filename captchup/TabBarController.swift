import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let indexToRemove = 4
        if indexToRemove < (self.viewControllers?.count)! {
            var viewControllers = self.viewControllers
            viewControllers?.remove(at: indexToRemove)
            self.viewControllers = viewControllers
        }
    }

}
