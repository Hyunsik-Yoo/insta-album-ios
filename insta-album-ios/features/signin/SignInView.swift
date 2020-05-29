import UIKit
import Then
import SnapKit
import Foundation

class SignInView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "인별액자"
        $0.textColor = .black
        $0.font = UIFont(name: "Ghanachocolate", size: 50)
    }
    
    let descLabel = UILabel().then {
        $0.text = "내 인스타그램 사진을\n액자로 활용해보세요."
        $0.textColor = .black
        $0.alpha = 0.8
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Ghanachocolate", size: 15)
    }
    
    let continueBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_insta"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageView?.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let bgImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "onboard1")
        $0.alpha = 0.6
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(bgImage, descLabel, titleLabel, continueBtn)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(150)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        continueBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }
}
