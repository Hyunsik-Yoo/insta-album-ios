import UIKit
import AVKit

class AlbumView: BaseView {
    
    let totalBtn = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
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
        addSubViews(collectionView, totalBtn)
    }
    
    override func bindConstraints() {
        totalBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }    
}
