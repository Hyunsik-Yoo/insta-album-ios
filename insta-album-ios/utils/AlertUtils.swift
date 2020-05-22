import UIKit

struct AlertViewUtil {
    
    static func show(vc: UIViewController, title: String? = nil, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showWithCancel(vc: UIViewController, title: String? = nil, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(vc: UIViewController, title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
