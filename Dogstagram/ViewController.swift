//Created by Real Life Swift on 22/12/2018

import UIKit

struct Item {
  var imageName: String
}

class ViewController: UIViewController {

  enum Mode {
    case view
    case select
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var items: [Item] = [Item(imageName: "1"),
                       Item(imageName: "2"),
                       Item(imageName: "3"),
                       Item(imageName: "4"),
                       Item(imageName: "5"),
                       Item(imageName: "6"),
                       Item(imageName: "7"),
                       Item(imageName: "8"),
                       Item(imageName: "9"),
                       Item(imageName: "10"),
                       Item(imageName: "11"),
                       Item(imageName: "12")]
  
  var collectionViewFlowLayout: UICollectionViewFlowLayout!
  let cellIdentifier = "ItemCollectionViewCell"
  let viewImageSegueIdentifier = "viewImageSegueIdentifier"
  
  var mMode: Mode = .view {
    didSet {
      switch mMode {
      case .view:
        for (key, value) in dictionarySelectedIndecPath {
          if value {
            collectionView.deselectItem(at: key, animated: true)
          }
        }
        
        dictionarySelectedIndecPath.removeAll()
        
        selectBarButton.title = "Select"
        navigationItem.leftBarButtonItem = nil
        collectionView.allowsMultipleSelection = false
      case .select:
        selectBarButton.title = "Cancel"
        navigationItem.leftBarButtonItem = deleteBarButton
        collectionView.allowsMultipleSelection = true
      }
    }
  }
  
  lazy var selectBarButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
    return barButtonItem
  }()

  lazy var deleteBarButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
    return barButtonItem
  }()
  
  var dictionarySelectedIndecPath: [IndexPath: Bool] = [:]
  
  let lineSpacing: CGFloat = 5
  let interItemSpacing: CGFloat = 5
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupBarButtonItems()
    setupCollectionView()
    setupCollectionViewItemSize()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let item = sender as! Item
    
    if segue.identifier == viewImageSegueIdentifier {
      if let vc = segue.destination as? ImageViewerViewController {
        vc.imageName = item.imageName
      }
    }
  }
  
  private func setupBarButtonItems() {
    navigationItem.rightBarButtonItem = selectBarButton
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
  }
  
  private func setupCollectionViewItemSize() {
    let customLayout = CustomLayout()
    customLayout.delegate = self
    collectionView.collectionViewLayout = customLayout
  }
  
  @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
    mMode = mMode == .view ? .select : .view
  }
  
  @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
    var deleteNeededIndexPaths: [IndexPath] = []
    for (key, value) in dictionarySelectedIndecPath {
      if value {
        deleteNeededIndexPaths.append(key)
      }
    }
    
    for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
      items.remove(at: i.item)
    }
    
    collectionView.deleteItems(at: deleteNeededIndexPaths)
    dictionarySelectedIndecPath.removeAll()
  }
  
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
    
    cell.imageView.image = UIImage(named: items[indexPath.item].imageName)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch mMode {
    case .view:
      collectionView.deselectItem(at: indexPath, animated: true)
      let item = items[indexPath.item]
      performSegue(withIdentifier: viewImageSegueIdentifier, sender: item)
    case .select:
      dictionarySelectedIndecPath[indexPath] = true
    }
  }
    
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if mMode == .select {
      dictionarySelectedIndecPath[indexPath] = false
    }
  }
  
}

extension ViewController: CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
    return UIImage(named: items[indexPath.item].imageName)!.size
  }
}

