import RxSwift

class HomeViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var instagramService: InstagramServiceProtocol
    var userDefaults: UserDefaultsUtils
    
    struct Input {
        var tapAlbumMode: AnyObserver<Void>
        var loadMore: AnyObserver<Int>
    }
    
    struct Output {
        var medias: Observable<[Media]>
        var showLoading: Observable<Bool>
        var showAlert: Observable<(String, String)>
        var showAlbumMode: Observable<[Media]>
    }
    
    let tapAlbumModePublisher = PublishSubject<Void>()
    let loadMorePublisher = PublishSubject<Int>()
    
    let mediasPublisher = PublishSubject<[Media]>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let showAlbumModePublisher = PublishSubject<[Media]>()
    
    let nextTokenPublisher = PublishSubject<String>()
    
    init(instagramService: InstagramServiceProtocol,
         userDefaults: UserDefaultsUtils) {
        self.instagramService = instagramService
        self.userDefaults = userDefaults
        
        input = Input(tapAlbumMode: tapAlbumModePublisher.asObserver(),
                      loadMore: loadMorePublisher.asObserver())
        output = Output(medias: mediasPublisher,
                        showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher,
                        showAlbumMode: showAlbumModePublisher)
        super.init()
        
        tapAlbumModePublisher.withLatestFrom(mediasPublisher).bind(to: showAlbumModePublisher)
            .disposed(by: disposeBag)
        
        loadMorePublisher.withLatestFrom(Observable.combineLatest(loadMorePublisher, mediasPublisher, nextTokenPublisher)).bind { [weak self] (row, currentMedias, nextToken) in
            guard let self = self else { return }
            
            if row >= currentMedias.count - 1 && !nextToken.isEmpty{
                self.showLoadingPublisher.onNext(true)
                instagramService.nextPageAlbum(nextToken: nextToken) { (mediasObservable) in
                    mediasObservable.subscribe(onNext: { (medias, nextToken) in
                        // 붙여넣기
                        self.mediasPublisher.onNext(currentMedias + medias)
                        self.nextTokenPublisher.onNext(nextToken)
                        self.showLoadingPublisher.onNext(false)
                    }, onError: { (error) in
                        if let error = error as? CommonError {
                            self.showAlertPublisher.onNext(("앨범 조회 오류", error.description))
                        } else {
                            self.showAlertPublisher.onNext(("앨범 조회 오류", error.localizedDescription))
                        }
                        self.showLoadingPublisher.onNext(false)
                    }).disposed(by: self.disposeBag)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func fetchAlbum() {
        self.showLoadingPublisher.onNext(true)
        instagramService.fetchAlbum(token: userDefaults.getToken()!) { [weak self] (mediasObservable) in
            guard let self = self else { return }
    
            mediasObservable.subscribe(onNext: { (medias, nextToken) in
                self.mediasPublisher.onNext(medias)
                self.nextTokenPublisher.onNext(nextToken)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("앨범 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("앨범 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
}
