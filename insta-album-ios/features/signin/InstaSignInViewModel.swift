import RxSwift

class InstaSignInViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var instagramService: InstagramServiceProtocol
    var userDefaults: UserDefaultsUtils
    
    
    struct Input {
        var code: AnyObserver<String>
    }
    
    struct Output {
        var showLoading: Observable<Bool>
        var showAlert: Observable<(String, String)>
        var dismissVC: Observable<Void>
    }
    
    let codePublisher = PublishSubject<String>()
    
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let dismissVCPublisher = PublishSubject<Void>()
    
    init(instagramService: InstagramServiceProtocol, userDefaults: UserDefaultsUtils) {
        self.instagramService = instagramService
        self.userDefaults = userDefaults
        
        input = Input(code: codePublisher.asObserver())
        output = Output(showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher,
                        dismissVC: dismissVCPublisher)
        super.init()
        
        codePublisher.bind { [weak self] (code) in
            guard let self = self else { return }
            
            self.showLoadingPublisher.onNext(true)
            instagramService.requestToken(code: code) { (authObservable) in
                authObservable.subscribe(onNext: { (token, id) in
                    self.userDefaults.setID(id: id)
                    
                    instagramService.requestLongLiveToken(token: token) { (longLiveTokenObservable) in
                        longLiveTokenObservable.subscribe(onNext: { (longLiveToken) in
                            self.userDefaults.setToken(token: longLiveToken.access_token)
                            self.dismissVCPublisher.onNext(())
                            self.showLoadingPublisher.onNext(false)
                        }, onError: { (error) in
                            if let error = error as? CommonError {
                                self.showAlertPublisher.onNext(("Long토큰 요청 오류", error.description))
                            } else {
                                self.showAlertPublisher.onNext(("Long토큰 요청 오류", error.localizedDescription))
                            }
                            self.showLoadingPublisher.onNext(false)
                        }).disposed(by: self.disposeBag)
                    }
                }, onError: { (error) in
                    if let error = error as? CommonError {
                        self.showAlertPublisher.onNext(("토큰 요청 오류", error.description))
                    } else {
                        self.showAlertPublisher.onNext(("토큰 요청 오류", error.localizedDescription))
                    }
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
}
