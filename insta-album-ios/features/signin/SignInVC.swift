import UIKit

class SignInVC: BaseVC {
    
    private lazy var signInView = SignInView(frame: self.view.frame)
    private var viewModel = SignInViewModel(userDefaults: UserDefaultsUtils())
    
    static func instance() -> SignInVC {
        return SignInVC(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = signInView
        
        viewModel.validateToken()
    }
    
    override func bindViewModel() {
        viewModel.output.goToHome.bind(onNext: goToHome)
        .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        signInView.continueBtn.rx.tap.bind(onNext: presentInstaSignIn)
            .disposed(by: disposeBag)
    }
    
    private func presentInstaSignIn() {
        let instaSignInVC = InstaSignInVC.instance().then {
            ($0.topViewController as? InstaSignInVC)?.delegate = self
        }
        present(instaSignInVC, animated: true, completion: nil)
    }
    
    private func goToHome() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToHome()
        }
    }
}

extension SignInVC: InstaSignInDelegate {
    func onDismiss() {
        self.goToHome()
    }
}

