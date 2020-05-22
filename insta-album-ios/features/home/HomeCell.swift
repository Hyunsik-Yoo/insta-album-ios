import UIKit
import RxSwift
import RxCocoa

class HomeCell: BaseCollectionViewCell {
    
    static let registerId = "\(HomeCell.self)"
    
    let image = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    let like = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(image, like)
    }
    
    override func bindConstraints() {
        image.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        like.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(image).offset(-10)
            make.width.height.equalTo(20)
        }
    }
    
    func bind(media: Media) {
        if let thumbnail = media.thumbnail_url {
            image.setImage(urlString: thumbnail)
        } else {
            image.setImage(urlString: media.media_url)
        }
    }
}
