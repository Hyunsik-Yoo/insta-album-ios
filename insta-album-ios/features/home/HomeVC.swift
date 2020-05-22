import UIKit

class HomeVC: BaseVC {
    
    private lazy var homeView = HomeView(frame: self.view.frame)
    private var viewModel = HomeViewModel(instagramService: InstagramServices(),
                                          userDefaults: UserDefaultsUtils())
    
    static func instance() -> UINavigationController {
        let controller = HomeVC(nibName: nil, bundle: nil)
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        view = homeView
        setupNavigation()
        setupCollectionView()
        viewModel.fetchAlbum()
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        viewModel.output.medias.bind(to: homeView.collectionView.rx.items(cellIdentifier: HomeCell.registerId, cellType: HomeCell.self)) { row, media, cell in
            cell.bind(media: media)
        }.disposed(by: disposeBag)
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertViewUtil.show(vc: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: homeView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showAlbumMode.bind(onNext: showAlbumMode(medias:))
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        // 앨범 모드 실행
        navigationItem.leftBarButtonItem?.rx.tap.bind(to: viewModel.input.tapAlbumMode)
            .disposed(by: disposeBag)
    }
    
    private func setupNavigation() {
        title = "인스타 앨범"
        
        let albumBtn = UIBarButtonItem(title: "앨범재생", style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = albumBtn
    }
    
    private func setupCollectionView() {
        homeView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        homeView.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.registerId)
    }
    
    private func showAlbumMode(medias: [Media]) {
        if (!medias.isEmpty) {
            let controller = AlbumVC.instance().then {
                $0.hidesBottomBarWhenPushed = true
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 - 2, height: UIScreen.main.bounds.width/3 - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.input.loadMore.onNext(indexPath.row)
    }
}

