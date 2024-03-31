

import Foundation

struct GitRepoModel: Codable {
    
    var name: String // repo이름
    var html_url: String // url주소
    var language: String? // repo사용된 언어
}
