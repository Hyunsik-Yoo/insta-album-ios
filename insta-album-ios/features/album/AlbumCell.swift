import UIKit
import AVKit


protocol AlbumCellDelegate: class {
    func onFinishVideo()
}

class AlbumCell: BaseCollectionViewCell {
    static let registerId = "\(AlbumCell.self)"
    
    weak var delegate: AlbumCellDelegate?
    
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
    
    func startVideo() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player?.play()
    }
    
    @objc
    func playerDidFinishPlaying(note: NSNotification) {
        self.delegate?.onFinishVideo()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupAVPlayer(videoURL: String) {
        player = AVPlayer(url: URL(string: videoURL)!)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer!)
        playerLayer?.frame = bounds
    }
}
