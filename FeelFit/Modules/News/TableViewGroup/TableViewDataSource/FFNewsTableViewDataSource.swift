//
//  FFNewsTableViewDataSource.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

class FFNewsTableViewDataSource: NSObject, UITableViewDataSource, TableViewCellDelegate {
  
    var cellDataModel = [Articles]()
    init(with cellDataModel: [Articles] = [Articles]()) {
        self.cellDataModel = cellDataModel
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFNewsPageTableViewCell.identifier, for: indexPath) as! FFNewsPageTableViewCell
        let data = cellDataModel[indexPath.row]
        cell.configureCell(model: data)
        cell.delegate = self
        return cell
    }
    
    func imageWasSelected(imageView: UIImageView?) {
        let vc = FFNewsImageViewController(imageView: imageView)
    }
    
    func buttonDidTapped(sender: UITableViewCell,status: Bool) {
        if status {
            print("Added to favourite")
        } else {
            print("Removed from favourite")
        }
    }
    
}


///Test class for opening imageView by user
class FFNewsImageViewController: UIViewController {
    
    var imageView: UIImageView?
    
    init(imageView: UIImageView? = UIImageView()) {
        self.imageView = imageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        
        imageView?.contentMode = .scaleAspectFit
        imageView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView?.center = self.view.center
        self.view.addSubview(imageView ?? UIImageView(image: UIImage(systemName: "photo")))
    }
}
