
import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    let gitManager = GitManager()
    
    var gitList = [GitModel]()
    var repoList = [GitRepoModel]()
    
    // MARK: - 프로필 이미지
    var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - 아이디
    var idLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "id"
        label.textAlignment = .left
        
        
        return label
    }()
    
    // MARK: - 지역정보
    var regionLabel: UILabel = {
        var label = UILabel()
        label.text = "region"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Follower
    var followerLabel: UILabel = {
        var label = UILabel()
        label.text = "Follwer"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Following
    var followingLabel: UILabel = {
        var label = UILabel()
        label.text = "Following"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - TableView
    var tableView : UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        //table.backgroundColor = .green
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        gitManager.delegate = self
        
        activateConstraints()
        gitManager.fetchRequest()
        gitManager.fetchRequestRepo()
    }
    
    
    // MARK: - Autolayout
    func activateConstraints() {
        view.addSubview(profileImageView)
        view.addSubview(idLabel)
        view.addSubview(regionLabel)
        view.addSubview(followerLabel)
        view.addSubview(followingLabel)
        view.addSubview(tableView)
        
        let imageViewConstraints = [profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10)
                                    ,profileImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -250)
                                    ,profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
                                    ,profileImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -600)]
        
        let idLabelConstraints = [idLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10)
                                  ,idLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                  ,idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
                                  ,idLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -720)]
        
        let regionLabelConstraints = [regionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10)
                                      ,regionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                      ,regionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 5)
                                      ,regionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -700)]
        
        let followerLabelConstraints = [followerLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
                                        ,followerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                        ,followerLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5)
                                        ,followerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -665)]
        
        let followingLabelConstraints = [followingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
                                         ,followingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                         ,followingLabel.topAnchor.constraint(equalTo: followerLabel.bottomAnchor, constant: 5)
                                         ,followingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -635)]
        
        let tableViewConstraints = [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5)
                                    ,tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10)
                                    ,tableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 5)
                                    ,tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(idLabelConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(followerLabelConstraints)
        NSLayoutConstraint.activate(followingLabelConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
}


// MARK: - TableView 기능
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        cell.textLabel?.text = repoList[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: repoList[indexPath.row].html_url) {
            UIApplication.shared.open(url)
        }
    }
}


// MARK: - GitManager로부터 User정보를 받아온다.
extension ViewController: SendProfile {
    func sendRepo(data: [GitRepoModel]) {
        repoList = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func sendData(data: [GitModel]) {
        gitList = data
        DispatchQueue.main.async {
            self.profileImageView.kf.setImage(with: URL(string: self.gitList[0].avatar_url))
            self.idLabel.text = "User ID : \(self.gitList[0].login)"
            self.regionLabel.text = "Location : \(self.gitList[0].location)"
            self.followerLabel.text = "Follower : \(String(self.gitList[0].followers))"
            self.followingLabel.text = "Following : \(String(self.gitList[0].following))"
        }
    }
}

#Preview{
    ViewController()
}
