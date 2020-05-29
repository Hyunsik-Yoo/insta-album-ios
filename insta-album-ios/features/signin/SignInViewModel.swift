import RxSwift

class SignInViewModel: BaseViewModel {
    var input: Input
    var output: Output
    var userDefaults: UserDefaultsUtils
    
    
    struct Input {
        var requestNextImage: AnyObserver<Void>
    }
    
    struct Output {
        var goToHome: Observable<Void>
        var showNextImage: Observable<UIImage>
    }
    
    let requestNextImagePublisher = PublishSubject<Void>()
    let goToHomePublisher = PublishSubject<Void>()
    let showNextImagePublisher = PublishSubject<UIImage>()
    
    let onboardingImages = [UIImage(named: "onboard1")!, UIImage(named: "onboard2")!, UIImage(named: "onboard3")!]
    var currentImageIndex = 0
    
    init(userDefaults: UserDefaultsUtils) {
        self.userDefaults = userDefaults
        
        input = Input(requestNextImage: requestNextImagePublisher.asObserver())
        output = Output(goToHome: goToHomePublisher,
                        showNextImage: showNextImagePublisher)
        super.init()
        
        requestNextImagePublisher.bind { [weak self] (_) in
            guard let self = self else { return }
            // 다음 이미지 가지고 와서 뿌려주기
            self.showNextImagePublisher.onNext(self.onboardingImages[self.currentImageIndex])
            self.currentImageIndex = self.currentImageIndex + 1 == self.onboardingImages.count ? 0 : self.currentImageIndex + 1
        }.disposed(by: disposeBag)
    }
    
    func validateToken() {
        if userDefaults.getID() != nil && userDefaults.getToken() != nil {
            goToHomePublisher.onNext(())
        }
    }
}
