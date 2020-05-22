import UIKit
import RxSwift
import RxCocoa

class AlbumVC: BaseVC {
    
    private lazy var albumView = AlbumView(frame: self.view.frame)
    
    private var media: [Media] = []
    private var currentIndex = 0
    
    static func instance(media: [Media]) -> AlbumVC {
        return AlbumVC(nibName: nil, bundle: nil).then {
            $0.media = media
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = albumView
        
        setupNavigation()
        startSlide()
    }
    
    override func bindEvent() {
        albumView.backBtn.rx.tap.bind { [weak self] (_) in
            guard let self = self else { return }
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popViewController(animated: true)
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
    
    private func startSlide() {
        Observable<Int>.timer(.seconds(0), period: .seconds(3), scheduler: MainScheduler.instance).bind { (_) in
            self.showNextPhoto()
        }.disposed(by: disposeBag)
    }
    
    private func showNextPhoto() {
        let currentMedia = media[currentIndex]
        
        albumView.bind(media: currentMedia)
        if currentIndex + 1 == media.count {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
}
