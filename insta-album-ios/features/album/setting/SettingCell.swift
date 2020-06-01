import UIKit

class SettingCell: BaseTableViewCell {
    static let registerId = "\(SettingCell.self)"
    
    let label = UILabel().then{
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.1)
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(label, bottomLine)
        selectionStyle = .none
    }
    
    override func bindConstraints() {
        bottomLine.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalTo(bottomLine.snp.top).offset(-15)
        }
    }
}
