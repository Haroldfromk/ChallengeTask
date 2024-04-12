

import Foundation

struct GitModel: Codable {
    
    var login : String // id
    var name : String // 이름
    var avatarUrl : String // profile image url
    var location : String // 지역
    var followers : Int // 팔로워 수
    var following : Int // 팔로잉 수
    
    enum CodingKeys: String, CodingKey {
        
        case login
        case name
        case avatarUrl = "avatar_url"
        case location
        case followers
        case following
        
    }
    
}
