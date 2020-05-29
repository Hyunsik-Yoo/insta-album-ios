import UIKit

class SettingView: BaseView {
    
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .black
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.tableFooterView = UIView()
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(nameLabel, tableView)
    }
    
    override func bindConstraints() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(80)
        }
    }
    
    func bind(user: InstaUser) {
        nameLabel.text = "이름: \(user.username)"
    }
}
