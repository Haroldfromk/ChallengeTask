

import Foundation
import Alamofire

protocol SendProfile: AnyObject {
    func sendData (data: GitModel?)
    func sendRepo (data: [GitRepoModel])
    func sendNext (hasNext: Bool)
}

class GitManager {
    
    weak var delegate : SendProfile?
    var repoLists = [GitRepoModel]()
    let url = "https://api.github.com/users/haroldfromk"
    let header: HTTPHeaders = ["Authorization": "Bearer Token"]
    
    // MARK: - 프로필 정보를 가져온다.
    func fetchRequest () {
        AF.request(url, method: .get, headers: header).responseDecodable(of: GitModel.self
        ) { response in
            switch response.result {
            case .success(let data) :
                do {
                    let profileList = GitModel(login: data.login, name: data.name, avatarUrl:  data.avatarUrl, location: data.location, followers: data.followers, following: data.following)
                    self.delegate?.sendData(data: profileList)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Repository 정보를 가져온다.
    func fetchRequestRepo () {
        AF.request(url+"/repos", method: .get, headers: header).responseDecodable(of: [GitRepoModel].self
        ) { response in
            self.repoLists.removeAll()
            switch response.result {
            case .success(let decodedData) :
                do {
                    for data in decodedData {
                        let list = GitRepoModel(name: data.name, htmlUrl: data.htmlUrl, language: data.language)
                        self.repoLists.append(list)
                    }
                    self.delegate?.sendRepo(data: self.repoLists)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Apple Repository 가져오기
    func fetchRequestAppleRepo (page: Int, hasNext: Bool) {
        if hasNext {
            let appleURL = "https://api.github.com/users/apple/repos?page="
            AF.request(appleURL+String(page), method: .get, headers: header).responseDecodable(of: [GitRepoModel].self
            ) { response in
                switch response.result {
                case .success(let decodedData) :
                    if !decodedData.isEmpty { // 더 가져올게 있다면
                        if decodedData.count == 30 { // api에서 가져오는 repository 개수는 30개로 확인되었다.
                            do {
                                for data in decodedData {
                                    let list = GitRepoModel(name: data.name, htmlUrl: data.htmlUrl, language: data.language)
                                    self.repoLists.append(list)
                                }
                                self.delegate?.sendRepo(data: self.repoLists)
                                self.delegate?.sendNext(hasNext: true)
                            }
                        } else {
                            do { // 30개가 아닐때 즉 마지막페이지일때
                                for data in decodedData {
                                    let list = GitRepoModel(name: data.name, htmlUrl: data.htmlUrl, language: data.language)
                                    self.repoLists.append(list)
                                }
                                self.delegate?.sendRepo(data: self.repoLists)
                                self.delegate?.sendNext(hasNext: false)
                            }
                        }
                    } else { // 마지막페이지를 지나 더이상 값을 가져오지 못할때
                        self.delegate?.sendNext(hasNext: false)
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
