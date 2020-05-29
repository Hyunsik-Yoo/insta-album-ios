import RxSwift

class SettingViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var instaService: InstagramServiceProtocol
    var userDefaults: UserDefaultsUtils
    
    struct Input {
        let signOut: AnyObserver<Void>
    }
    
    struct Output {
        let showUserInfo: Observable<InstaUser>
        let showLoading: Observable<Bool>
        let showAlert: Observable<(String, String)>
        let goToSignIn: Observable<Void>
    }
    
    let signOutPublisher = PublishSubject<Void>()
    let showUserInfoPublisher = PublishSubject<InstaUser>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let goToSignInPublisher = PublishSubject<Void>()
    
    init(instaService: InstagramServiceProtocol,
         userDefaults: UserDefaultsUtils) {
        self.instaService = instaService
        self.userDefaults = userDefaults
        input = Input(signOut: signOutPublisher.asObserver())
        output = Output(showUserInfo: showUserInfoPublisher,
                        showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher,
                        goToSignIn: goToSignInPublisher)
        super.init()
        
        signOutPublisher.bind { [weak self] (_) in
            guard let self = self else { return }
            self.userDefaults.clear()
            self.goToSignInPublisher.onNext(())
        }.disposed(by: disposeBag)
    }
    
    func fetchUserInfo() {
        self.showLoadingPublisher.onNext(true)
        instaService.getMyInfo(token: userDefaults.getToken()!) { [weak self] (userObservable) in
            guard let self = self else { return }
            userObservable.subscribe(onNext: { (instaUser) in
                self.showUserInfoPublisher.onNext(instaUser)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("유저 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("유저 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
}
