
import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    let gitManager = GitManager()
    
    var gitList: [GitModel] = []
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
    
    // MARK: - 이름
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "name"
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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
    }
    
    @objc func didPullToRefresh() {
        gitManager.fetchRequestRepo()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Autolayout
    func activateConstraints() {
        view.addSubview(profileImageView)
        view.addSubview(idLabel)
        view.addSubview(nameLabel)
        view.addSubview(regionLabel)
        view.addSubview(followerLabel)
        view.addSubview(followingLabel)
        view.addSubview(tableView)
        
        let imageViewConstraints = [profileImageView.heightAnchor.constraint(equalToConstant: 150),
                                    profileImageView.widthAnchor.constraint(equalToConstant: 150)
                                    ,profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10)
                                    ,profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        
        let idLabelConstraints = [idLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10)
                                  ,idLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                  ,idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15)
        ]
        
        let nameLabelConstraints = [nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10)
                                    ,nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                    ,nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 5)]
        
        let regionLabelConstraints = [regionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10)
                                      ,regionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                      ,regionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ]
        
        let followerLabelConstraints = [followerLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
                                        ,followerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                        ,followerLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5)
        ]
        
        let followingLabelConstraints = [followingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
                                         ,followingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
                                         ,followingLabel.topAnchor.constraint(equalTo: followerLabel.bottomAnchor, constant: 5)
        ]
        
        let tableViewConstraints = [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5)
                                    ,tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10)
                                    ,tableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 10)
                                    ,tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(idLabelConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
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
            self.nameLabel.text = "Name : \(self.gitList[0].name)"
            self.regionLabel.text = "Location : \(self.gitList[0].location)"
            self.followerLabel.text = "Follower : \(String(self.gitList[0].followers))"
            self.followingLabel.text = "Following : \(String(self.gitList[0].following))"
        }
    }
}

#Preview{
    ViewController()
}
