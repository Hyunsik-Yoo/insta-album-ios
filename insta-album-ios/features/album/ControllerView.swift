import UIKit

class ControllerView: BaseView {
    
    let tapGesture = UITapGestureRecognizer()
    
    let settingBtn = UIButton().then {
        $0.setTitle("설정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Ghanachocolate", size: 30)
    }
    
    let totalBtn = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Ghanachocolate", size: 30)
    }
    
    
    override func setup() {
        setupBlur()
        addSubViews(settingBtn, totalBtn)
        addGestureRecognizer(tapGesture)
    }
    
    override func bindConstraints() {
        settingBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        totalBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
