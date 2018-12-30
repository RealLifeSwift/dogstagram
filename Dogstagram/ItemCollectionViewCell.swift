//Created by Real Life Swift on 22/12/2018

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var highlightIndicator: UIView!
  @IBOutlet weak var selectIndicator: UIImageView!
  
  override var isHighlighted: Bool {
    didSet {
      highlightIndicator.isHidden = !isHighlighted
    }
  }
  
  override var isSelected: Bool {
    didSet {
      highlightIndicator.isHidden = !isSelected
      selectIndicator.isHidden = !isSelected
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
