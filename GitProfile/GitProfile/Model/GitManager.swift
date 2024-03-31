

import Foundation
import Alamofire

protocol SendProfile {
    func sendData (data: [GitModel])
    func sendRepo (data: [GitRepoModel])
}

class GitManager {
    
    var delegate : SendProfile?
    
    let url = "https://api.github.com/users/haroldfromk"
    
    var repoLists = [GitRepoModel]()
    
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
    
    func fetchRequestRepo () {
        
        
        AF.request(url+"/repos", method: .get).responseDecodable(of: [GitRepoModel].self
        ) { response in
            
            self.repoLists.removeAll()

            switch response.result {
            case .success(let data) :
                do {
                    for result in data {
                        let list = GitRepoModel(name: result.name, html_url: result.html_url)
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
