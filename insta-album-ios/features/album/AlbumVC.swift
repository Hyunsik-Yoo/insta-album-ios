import UIKit
import RxSwift
import RxCocoa

class AlbumVC: BaseVC {
    
    private lazy var albumView = AlbumView(frame: self.view.frame)
    private var viewModel = AlbumViewModel(instagramService: InstagramServices(),
                                           userDefaults: UserDefaultsUtils())
    
    static func instance() -> UINavigationController {
        let controller = AlbumVC(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = albumView
        
        setupCollectionView()
        viewModel.fetchAlbum()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    override func bindEvent() {
        albumView.totalBtn.rx.tap.bind(onNext: goToHome)
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.output.medias.bind(to: albumView.collectionView.rx.items(cellIdentifier: AlbumCell.registerId, cellType: AlbumCell.self)) { row, media, cell in
            cell.bind(media: media)
        }.disposed(by: disposeBag)
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertViewUtil.show(vc: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: albumView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showNext.bind { [weak self] (index) in
            guard let self = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.albumView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }.disposed(by: disposeBag)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCollectionView() {
        albumView.collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.registerId)
        albumView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func goToHome() {
        navigationController?.pushViewController(HomeVC.instance(), animated: true)
    }
}

extension AlbumVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.input.loadMore.onNext(indexPath.row)
        viewModel.nextIndexPublisher.onNext(indexPath.row)
        if let albumCell = cell as? AlbumCell {
            albumCell.player?.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let albumCell = cell as? AlbumCell {
            albumCell.player?.pause()
        }
    }
}
