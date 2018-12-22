//Created by Real Life Swift on 22/12/2018

import UIKit

class ImageViewerViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var imageName: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupImageView()
  }
  
  private func setupImageView() {
    guard let name = imageName else { return }
    
    if let image = UIImage(named: name) {
      imageView.image = image
    }
  }
  
  
}
