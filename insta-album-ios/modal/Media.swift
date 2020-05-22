import Foundation

struct Media: Codable {
    var id: String
    var media_type: String
    var media_url: String
    var thumbnail_url: String?
    var timestamp: String
    var username: String
}
