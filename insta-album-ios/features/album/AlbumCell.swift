import UIKit

class AlbumCell: BaseCollectionViewCell {
    static let registerId = "\(AlbumCell.self)"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(imageView)
    }
    
    override func bindConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func bind(media: Media) {
        if let thumbnail = media.thumbnail_url {
            self.imageView.setImage(urlString: thumbnail)
        } else {
            self.imageView.setImage(urlString: media.media_url)
        }
    }

}
