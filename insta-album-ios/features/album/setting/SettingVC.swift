import UIKit

class SettingVC: BaseVC {
    
    private lazy var settingView = SettingView(frame: self.view.frame)
    
    private var viewModel = SettingViewModel(instaService: InstagramServices(),
                                             userDefaults: UserDefaultsUtils())
    
    static func instance() -> UINavigationController {
        let controller = SettingVC(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingView
        setupNavigation()
        setupTableView()
        viewModel.fetchUserInfo()
    }
    
    override func bindViewModel() {
        viewModel.output.showLoading.bind(onNext: settingView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertViewUtil.show(vc: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.showUserInfo.bind(onNext: settingView.bind(user:))
            .disposed(by: disposeBag)
        viewModel.output.goToSignIn.bind(onNext: goToSignIn)
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        
    }
    
    private func setupNavigation() {
        title = "설정"
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupTableView() {
        settingView.tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.registerId)
        settingView.tableView.dataSource = self
        settingView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func goToSignIn() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToSignIn()
        }
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.registerId, for: indexPath) as? SettingCell else {
            return BaseTableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "로그아웃"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            AlertViewUtil.showWithCancel(vc: self, title: "로그아웃", message: "로그아웃하시겠습니까?") { [weak self] (_) in
                guard let self = self else { return }
                self.viewModel.input.signOut.onNext(())
            }
        }
    }
    
    
}
