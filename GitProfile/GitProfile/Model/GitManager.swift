

import Foundation
import Alamofire

protocol SendProfile {
    func sendData (data: [GitModel])
    func sendRepo (data: [GitRepoModel])
}

class GitManager {
    
    var delegate : SendProfile?
    var repoLists = [GitRepoModel]()
    
    let url = "https://api.github.com/users/haroldfromk"
    
    // MARK: - 프로필 정보를 가져온다.
    func fetchRequest () {
        
        AF.request(url, method: .get).responseDecodable(of: GitModel.self
        ) { response in
           
            switch response.result {
            case .success(let data) :
                do {
                    let profileList = GitModel(login: data.login, name: data.name, avatar_url: data.avatar_url, location: data.location, followers: data.followers, following: data.following)
        
                    self.delegate?.sendData(data: [profileList])
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Repository 정보를 가져온다.
    func fetchRequestRepo () {

        AF.request(url+"/repos", method: .get).responseDecodable(of: [GitRepoModel].self
        ) { response in
            
            self.repoLists.removeAll()

            switch response.result {
            case .success(let decodedData) :
                do {
                    for data in decodedData {
                        let list = GitRepoModel(name: data.name, html_url: data.html_url, language: data.language)
                        self.repoLists.append(list)
                    }
                    self.delegate?.sendRepo(data: self.repoLists)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRequestAppleRepo (page: Int, hasNext: Bool) {
        
        var gap = repoLists.count
        
        if hasNext {
            let appleURL = "https://api.github.com/users/apple/repos?page="
            
            AF.request(appleURL+String(page), method: .get).responseDecodable(of: [GitRepoModel].self
            ) { response in
                switch response.result {
                case .success(let decodedData) :
                    do {
                        for data in decodedData {
                            let list = GitRepoModel(name: data.name, html_url: data.html_url, language: data.language)
                            self.repoLists.append(list)
                        }
                        self.delegate?.sendRepo(data: self.repoLists)
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
