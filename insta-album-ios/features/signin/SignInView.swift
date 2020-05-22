import UIKit
import Then
import SnapKit

class SignInView: BaseView {
    let continueBtn = UIButton().then {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitle("인스타로 계속하기", for: .normal)
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(continueBtn)
    }
    
    override func bindConstraints() {
        continueBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
    }
}
