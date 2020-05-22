struct HTTPUtils {
    static let requestTokenURL = "https://api.instagram.com/oauth/access_token"
    static let requestLongLiveTokenURL = "https://graph.instagram.com/access_token"
    static let graphURL = "https://graph.instagram.com/me/media"
    
    static func jsonHeader() -> [String: String] {
        return ["Accept": "application/json"]
    }
}
