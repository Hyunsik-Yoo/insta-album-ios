import Foundation

struct UserDefaultsUtils {
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_ID = "KEY_ID" // 무료 혈당지 튜토리얼을 경험 했는지?
    
    let instance: UserDefaults
    
    init(name: String? = nil) {
        if let name = name {
            UserDefaults().removePersistentDomain(forName: name)
            instance = UserDefaults(suiteName: name)!
        } else {
            instance = UserDefaults.standard
        }
    }
    
    func setToken(token: String) {
        instance.set(token, forKey: UserDefaultsUtils.KEY_TOKEN)
    }
    
    func getToken() -> String? {
        return instance.string(forKey: UserDefaultsUtils.KEY_TOKEN)
    }
    
    func setID(id: Int) {
        instance.set(id, forKey: UserDefaultsUtils.KEY_ID)
    }
    
    func getID() -> Int? {
        return instance.integer(forKey: UserDefaultsUtils.KEY_ID)
    }
    
    func clear() {
        instance.removeObject(forKey: UserDefaultsUtils.KEY_ID)
        instance.removeObject(forKey: UserDefaultsUtils.KEY_TOKEN)
    }
}
