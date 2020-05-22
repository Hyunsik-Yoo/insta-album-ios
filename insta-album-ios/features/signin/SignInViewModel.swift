import RxSwift

class SignInViewModel: BaseViewModel {
    
    var output: Output
    var userDefaults: UserDefaultsUtils
    
    struct Output {
        var goToHome: Observable<Void>
    }
    
    let goToHomePublisher = PublishSubject<Void>()
    
    init(userDefaults: UserDefaultsUtils) {
        self.userDefaults = userDefaults
        
        output = Output(goToHome: goToHomePublisher)
        
        super.init()
    }
    
    func validateToken() {
        if userDefaults.getID() != nil && userDefaults.getToken() != nil {
            goToHomePublisher.onNext(())
        }
    }
}
