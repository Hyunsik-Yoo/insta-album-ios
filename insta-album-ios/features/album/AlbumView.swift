import UIKit
import AVKit

class AlbumView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setTitle("뒤로가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
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
        addSubViews(collectionView, backBtn)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }    
}
