import RxSwift
import Alamofire

protocol InstagramServiceProtocol {
    func requestToken(code: String, completion: @escaping ((Observable<(String, Int)>) -> Void))
    func requestLongLiveToken(token: String, completion: @escaping ((Observable<LongLiveToken>) -> Void))
    func fetchAlbum(token: String, completion: @escaping ((Observable<([Media], String)>) -> Void))
    func nextPageAlbum(nextToken: String, completion: @escaping ((Observable<([Media], String)>) -> Void))
    func getMyInfo(token: String, completion: @escaping ((Observable<InstaUser>) -> Void))
}

struct InstagramServices: InstagramServiceProtocol {
    
    func requestToken(code: String, completion: @escaping ((Observable<(String, Int)>) -> Void)) {
        let url = HTTPUtils.requestTokenURL
        let headers = HTTPUtils.jsonHeader()
        let params: [String: Any] = ["client_id": "244637603533699",
                                     "client_secret": "9864f4623a31573ea7f51a6d058b34b6",
                                     "code": code,
                                     "grant_type": "authorization_code",
                                     "redirect_uri": "https://mcflynn.tistory.com/"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let instagramToken: InstagramToken = JsonUtils.toJson(object: value) {
                    completion(Observable.just((instagramToken.access_token, instagramToken.user_id)))
                } else {
                    let error = CommonError(desc: "value is nil")
                    completion(Observable.error(error))
                }
            }
        }
    }
    
    func requestLongLiveToken(token: String, completion: @escaping ((Observable<LongLiveToken>) -> Void)) {
        let url = HTTPUtils.requestLongLiveTokenURL
        let headers = HTTPUtils.jsonHeader()
        let params: [String: Any] = ["grant_type": "ig_exchange_token",
                                     "client_secret": "9864f4623a31573ea7f51a6d058b34b6",
                                     "access_token": token]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let longLiveToken: LongLiveToken = JsonUtils.toJson(object: value) {
                    completion(Observable.just(longLiveToken))
                } else {
                    let error = CommonError(desc: "LongliveToken mapping error")
                    completion(Observable.error(error))
                }
            } else {
                let error = CommonError(desc: "Value is nil")
                completion(Observable.error(error))
            }
        }
    }
    
    func fetchAlbum(token: String, completion: @escaping ((Observable<([Media], String)>) -> Void)) {
        let url = HTTPUtils.graphURL
        let headers = HTTPUtils.jsonHeader()
        let params: [String: Any] = ["fields": "id,media_type,media_url,thumbnail_url,username,timestamp",
                                     "access_token": token]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let instagramResponse: InstagramResponse<Media> = JsonUtils.toJson(object: value) {
                    if let data = instagramResponse.data {
                        completion(Observable.just((data, instagramResponse.paging.next ?? "")))
                    } else {
                        let error = CommonError(desc: "data is nil")
                        completion(Observable.error(error))
                    }
                } else {
                    let error = CommonError(desc: "Instagram response mapping error")
                    completion(Observable.error(error))
                }
            } else {
                let error = CommonError(desc: "value is nil")
                completion(Observable.error(error))
            }
        }
    }
    
    func nextPageAlbum(nextToken: String, completion: @escaping ((Observable<([Media], String)>) -> Void)) {
        let headers = HTTPUtils.jsonHeader()
        Alamofire.request(nextToken, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let instagramResponse: InstagramResponse<Media> = JsonUtils.toJson(object: value) {
                    if let data = instagramResponse.data {
                        completion(Observable.just((data, instagramResponse.paging.next ?? "")))
                    } else {
                        let error = CommonError(desc: "data is nil")
                        completion(Observable.error(error))
                    }
                } else {
                    let error = CommonError(desc: "Instagram response mapping error")
                    completion(Observable.error(error))
                }
            } else {
                let error = CommonError(desc: "value is nil")
                completion(Observable.error(error))
            }
        }
    }
    
    func getMyInfo(token: String, completion: @escaping ((Observable<InstaUser>) -> Void)) {
        let url = "https://graph.instagram.com/me"
        let headers = HTTPUtils.jsonHeader()
        let params: [String: Any] = ["fields": "username", "access_token": token]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let instaUser: InstaUser = JsonUtils.toJson(object: value) {
                    completion(Observable.just(instaUser))
                } else {
                    let error = CommonError(desc: "serialization error")
                    completion(Observable.error(error))
                }
            } else {
                let error = CommonError(desc: "value is nil")
                completion(Observable.error(error))
            }
        }
    }
}
