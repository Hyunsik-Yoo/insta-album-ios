import UIKit
import WebKit

protocol InstaSignInDelegate {
    func onDismiss()
}

class InstaSignInVC: BaseVC {
    
    private lazy var instaSignInView = InstaSignInView(frame: self.view.frame)
    private var viewModel = InstaSignInViewModel(instagramService: InstagramServices(),
                                                 userDefaults: UserDefaultsUtils())
    var delegate: InstaSignInDelegate?
    
    static func instance() -> UINavigationController {
        let controller = InstaSignInVC(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        view = instaSignInView
        setupNavigationBar()
        loadRequestURL()
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertViewUtil.show(vc: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: instaSignInView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.dismissVC.bind { [weak self] (_) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.onDismiss()
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        navigationItem.leftBarButtonItem?.rx.tap.bind(onNext: { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        title = "인스타로 계속하기"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.leftBarButtonItem = .init(title: "닫기", style: .plain, target: self, action: nil)
    }
    
    private func loadRequestURL() {
        let url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=244637603533699&redirect_uri=https://mcflynn.tistory.com/&scope=user_profile,user_media&response_type=code")
        let urlRequest = URLRequest(url: url!)
        
        instaSignInView.webView.navigationDelegate = self
        instaSignInView.webView.load(urlRequest)
    }
}

extension InstaSignInVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = webView.url,
        url.absoluteString.starts(with: "https://l.instagram.com/"),
            let params = url.absoluteString.removingPercentEncoding?.components(separatedBy: "code=")[1] {
            let code = params.components(separatedBy: "#_")[0]
            
            self.viewModel.input.code.onNext(code)
        }
        decisionHandler(.allow)
    }
}
