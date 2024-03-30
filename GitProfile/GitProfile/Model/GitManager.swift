

import Foundation
import Alamofire

protocol SendProfile {
    func sendData (data: [GitModel])
}

class GitManager {
    
    var delegate : SendProfile?
    
    let url = "https://api.github.com/users/haroldfromk"
    //let repoURL = "https://api.github.com/users/haroldfromk/repos"
    
    let parameter = [GitModel]()
    
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
    
}
