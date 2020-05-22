import UIKit
import AVKit

class AlbumCell: BaseCollectionViewCell {
    static let registerId = "\(AlbumCell.self)"
    
    
    var player: AVPlayer? = nil
    
    var playerLayer: AVPlayerLayer? = nil
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(imageView)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let playerLayer = playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        imageView.image = nil
    }
    
    override func bindConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func bind(media: Media) {
        if media.media_type == "VIDEO" {
            setupAVPlayer(videoURL: media.media_url)
        } else {
            if let thumbnail = media.thumbnail_url {
                self.imageView.setImage(urlString: thumbnail)
            } else {
                self.imageView.setImage(urlString: media.media_url)
            }
        }
    }
    
    private func setupAVPlayer(videoURL: String) {
        player = AVPlayer(url: URL(string: videoURL)!)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer!)
        playerLayer?.frame = bounds
    }
}
