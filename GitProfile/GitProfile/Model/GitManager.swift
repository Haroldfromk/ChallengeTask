

import Foundation
import Alamofire

protocol SendProfile {
    func sendData (data: [GitModel])
    func sendRepo (data: [GitRepoModel])
}

class GitManager {
    
    var delegate : SendProfile?
    
    let url = "https://api.github.com/users/haroldfromk"
    //let repoURL = "https://api.github.com/users/haroldfromk/repos"
    
    let parameter = [GitModel]()
    let repoParameter = [GitRepoModel]()
    
    var list = [GitRepoModel]()
    
    func fetchRequest () {
        
        AF.request(url, method: .get, parameters: parameter).responseDecodable(of: GitModel.self
        ) { response in
           
            switch response.result {
            case .success(let data) :
                do {
                    self.delegate?.sendData(data: [data])
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRequestRepo () {
        AF.request(url+"/repos", method: .get, parameters: repoParameter).responseDecodable(of: [GitRepoModel].self
        ) { response in
            
            switch response.result {
            case .success(let data) :
                do {
                    self.delegate?.sendRepo(data: data)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
}
