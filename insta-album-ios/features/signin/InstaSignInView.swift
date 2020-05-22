import UIKit
import WebKit

class InstaSignInView: BaseView {
    let webView = WKWebView()
    
    
    override func setup() {
        backgroundColor = .white
        addSubViews(webView)
    }
    
    override func bindConstraints() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
