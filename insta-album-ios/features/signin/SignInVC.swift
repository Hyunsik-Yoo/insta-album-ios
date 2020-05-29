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
        viewModel.input.requestNextImage.onNext(())
    }
    
    override func bindViewModel() {
        viewModel.output.goToHome.bind(onNext: goToAlbum)
        .disposed(by: disposeBag)
        viewModel.output.showNextImage.bind(onNext: startTransition(image:))
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
    
    private func goToAlbum() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToAlbum()
        }
    }
    
    private func startTransition(image: UIImage) {
        UIView.transition(with: signInView.bgImage, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.signInView.bgImage.image = image
        })
        UIView.animate(withDuration: 4.0, animations: { [weak self] in
            guard let self = self else { return }
            if self.signInView.bgImage.transform.isIdentity {
                self.signInView.bgImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else {
                self.signInView.bgImage.transform = CGAffineTransform.identity
            }
        }) { [weak self] (_) in
            self?.viewModel.input.requestNextImage.onNext(())
        }
    }
}

extension SignInVC: InstaSignInDelegate {
    func onDismiss() {
        self.goToAlbum()
    }
}

