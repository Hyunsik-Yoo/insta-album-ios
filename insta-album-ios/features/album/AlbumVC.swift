import UIKit
import RxSwift
import RxCocoa

class AlbumVC: BaseVC {
    
    private lazy var albumView = AlbumView(frame: self.view.frame)
    private lazy var controllerView = ControllerView(frame: self.view.frame).then {
        $0.alpha = 0
    }
    private var viewModel = AlbumViewModel(instagramService: InstagramServices(),
                                           userDefaults: UserDefaultsUtils())
    
    var timer: Timer? = nil
    
    static func instance() -> UINavigationController {
        let controller = AlbumVC(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubViews(albumView, controllerView)
        
        setupCollectionView()
        viewModel.fetchAlbum()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    override func bindEvent() {
        albumView.tapGesture.rx.event.bind { [weak self] (_) in
            guard let self = self else { return }
            self.showControllerView()
        }.disposed(by: disposeBag)
        controllerView.tapGesture.rx.event.bind { [weak self] (_) in
            guard let self = self else { return }
            self.showControllerView()
        }.disposed(by: disposeBag)
        controllerView.totalBtn.rx.tap.bind(onNext: showControllerView)
            .disposed(by: disposeBag)
        
        // ControllerView
        controllerView.totalBtn.rx.tap.bind(onNext: goToHome)
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.output.medias.bind(to: albumView.collectionView.rx.items(cellIdentifier: AlbumCell.registerId, cellType: AlbumCell.self)) { [weak self] row, media, cell in
            guard let self = self else { return }
            cell.bind(media: media)
            cell.delegate = self
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
    
    private func showControllerView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            if self.controllerView.alpha == 0 {
                self.controllerView.alpha = 1
            } else {
                self.controllerView.alpha =  0
            }
        }
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
        timer?.invalidate()
        viewModel.input.loadMore.onNext(indexPath.row)
        viewModel.nextIndexPublisher.onNext(indexPath.row)
        if let albumCell = cell as? AlbumCell {
            if let _ = albumCell.player {
                albumCell.startVideo()
            } else {
                // 사진일 경우 몇초 뒤에
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] (_) in
                    guard let self = self else { return }
                    self.viewModel.input.requestNext.onNext(())
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let albumCell = cell as? AlbumCell {
            albumCell.player?.pause()
        }
    }
}

extension AlbumVC: AlbumCellDelegate {
    func onFinishVideo() {
        self.viewModel.input.requestNext.onNext(())
    }
}
