//
//  TestViewController.swift
//  GitProfile
//
//  Created by Dongik Song on 3/29/24.
//

import UIKit

class TestViewController: UIViewController {
    
    
    var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "swift")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func autoLayout() {
        view.addSubview(imageView)
        
        let imageViewLayout = [
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 30),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
        
        NSLayoutConstraint.activate(imageViewLayout)
    }
    
}





//extension ViewController : UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return lists.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
//        cell.textLabel?.text = lists[indexPath.row]
//        
//        return cell
//    }
//    
//    
//}

#Preview {
    TestViewController()
    
}

