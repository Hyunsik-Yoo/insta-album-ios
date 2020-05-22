import UIKit
import AVKit

class AlbumView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setTitle("뒤로가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let imageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    let avPlayer = AVPlayer()
    
    
    override func setup() {
        backgroundColor = .black
        addSubViews(imageView, backBtn)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func bind(media: Media) {
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve, animations: {
            if let thumbnail = media.thumbnail_url {
                self.imageView.setImage(urlString: thumbnail)
            } else {
                self.imageView.setImage(urlString: media.media_url)
            }
        }, completion: nil)
    }
}
