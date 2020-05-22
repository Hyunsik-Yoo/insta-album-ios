import Foundation

struct LongLiveToken: Codable {
    var access_token: String
    var token_type: String
    var expires_in: Int
}
