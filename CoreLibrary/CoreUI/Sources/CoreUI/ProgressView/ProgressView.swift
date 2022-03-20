import UIKit

public final class ProgressView: UIView {
    
    private let progressWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert
        return window
    }()
    
    private let animationView = UIActivityIndicatorView()
    
    public enum Status {
        case loading
        case success
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static var instance = ProgressView()
    
    public func show(_ status: Status = .loading, animated: Bool = true) {
        progressWindow.makeKeyAndVisible()
        progressWindow.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        switch status {
        case .loading:
            animationView.startAnimating()
            addSubview(animationView)
            animationView.backgroundColor = .systemBlue.withAlphaComponent(0.5)
            animationView.tintColor = .white
            animationView.layer.cornerRadius = 20
            animationView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(Constants.animationSize)
            }
        case .success:
            break
        }
        
        if animated {
            alpha = 0.0
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1.0
            }
        }
    }
    
    private var isAnimating = false
    
    public func hideWithSuccess(completion: @escaping () -> Void) {
        isAnimating = true
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.subviews.forEach {
                    $0.alpha = 0.0
                }
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                    self.isAnimating = false
                    self.hide()
                    completion()
                }
                
            }
        )
    }
    
    public func hide(animated: Bool = false) {
        if !animated {
            hideNotAnimated()
            return
        }
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.alpha = 0.0
            },
            completion: { _ in
                self.hideNotAnimated()
            }
        )
    }
    
    public func hideIfNotAnimating() {
        if isAnimating { return }
        
        hide(animated: true)
    }
    
    private func hideNotAnimated() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.removeFromSuperview()
        self.progressWindow.isHidden = true
    }
}

private extension ProgressView {
    
    enum Constants {
        static let animationSize = 80
    }
}
