

import Foundation

struct GitRepoModel: Codable {
    
    var name: String // repo이름
    var htmlUrl: String // url주소
    var language: String? // repo사용된 언어
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case htmlUrl = "html_url"
        case language
        
    }
    
}
