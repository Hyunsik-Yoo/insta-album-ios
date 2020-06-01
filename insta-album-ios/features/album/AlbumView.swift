import UIKit
import AVKit

class AlbumView: BaseView {
    
    let tapGesture = UITapGestureRecognizer()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        $0.collectionViewLayout = layout
        $0.backgroundColor = .black
        $0.isPagingEnabled = true
    }
    
    
    override func setup() {
        backgroundColor = .black
        addSubViews(collectionView)
        addGestureRecognizer(tapGesture)
    }
    
    override func bindConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }    
}
