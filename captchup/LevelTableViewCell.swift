import UIKit

class LevelTableViewCell: UITableViewCell {

    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var levelImageViewExplore: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameLabelExplore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
