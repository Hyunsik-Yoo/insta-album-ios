import RxSwift


class AlbumViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var instagramService: InstagramServiceProtocol
    var userDefaults: UserDefaultsUtils
    
    struct Input {
        var loadMore: AnyObserver<Int>
    }
    
    struct Output {
        var medias: Observable<[Media]>
        var showLoading: Observable<Bool>
        var showAlert: Observable<(String, String)>
        var showNext: Observable<Int>
    }
    
    let loadMorePublisher = PublishSubject<Int>()
    let mediasPublisher = PublishSubject<[Media]>()
    
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let showNextPublisher = PublishSubject<Int>()
    
    let nextIndexPublisher = BehaviorSubject(value: 0)
    let nextTokenPublisher = PublishSubject<String>()
    
    init(instagramService: InstagramServiceProtocol,
         userDefaults: UserDefaultsUtils) {
        self.instagramService = instagramService
        self.userDefaults = userDefaults
        
        input = Input(loadMore: loadMorePublisher.asObserver())
        output = Output(medias: mediasPublisher,
                        showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher,
                        showNext: showNextPublisher)
        super.init()
        
        loadMorePublisher.withLatestFrom(Observable.combineLatest(loadMorePublisher, mediasPublisher, nextTokenPublisher)).bind { [weak self] (row, currentMedias, nextToken) in
            guard let self = self else { return }
            if row >= currentMedias.count - 1 && !nextToken.isEmpty{
                instagramService.nextPageAlbum(nextToken: nextToken) { (mediasObservable) in
                    mediasObservable.subscribe(onNext: { (medias, nextToken) in
                        self.mediasPublisher.onNext(currentMedias + medias)
                        self.nextTokenPublisher.onNext(nextToken)
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
        
        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(nextIndexPublisher, mediasPublisher)).bind { [weak self] (index, medias) in
                guard let self = self else { return }
                
                if index >= medias.count {
                    self.nextIndexPublisher.onNext(0)
                    self.showNextPublisher.onNext(0)
                } else {
                    self.nextIndexPublisher.onNext(index + 1)
                    self.showNextPublisher.onNext(index + 1)
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
