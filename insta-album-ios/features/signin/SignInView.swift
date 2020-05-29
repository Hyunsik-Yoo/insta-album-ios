import UIKit
import Then
import SnapKit
import Foundation

class SignInView: BaseView {
    let continueBtn = UIButton().then {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitle("인스타로 계속하기", for: .normal)
    }
    
    let bgImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "onboard1")
        $0.alpha = 0.6
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(bgImage, continueBtn)
    }
    
    override func bindConstraints() {
        
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        continueBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
    }
}
