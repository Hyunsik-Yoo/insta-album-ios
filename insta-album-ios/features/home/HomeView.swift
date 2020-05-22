import UIKit

class HomeView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
    }
    
    
    override func setup() {
        backgroundColor = .white
        addSubViews(collectionView)
    }
    
    override func bindConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
}
