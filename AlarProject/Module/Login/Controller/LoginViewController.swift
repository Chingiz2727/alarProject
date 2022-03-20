import UIKit
import CoreUI

final class LoginViewController: UIViewController, LoginModule, ViewOwner {
    typealias RootView = LoginView
    
    var viewModel: LoginViewModel!
    var onSuccess: OnSuccess?

    override func loadView() {
        view = LoginView()
        title = "Авторизация"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
    }
    
    @objc private func sendLoginResponse() {
        ProgressView.instance.show(.loading, animated: true)
        guard let password = rootView.passwordTextField.text, let login = rootView.usernameTextField.text else {
            showSnackbar("Заполните все данные")
            return
        }
        viewModel.makeLogin(userName: login, password: password)
    }
    
    private func configureView() {
        rootView.sendButton.addTarget(self, action: #selector(sendLoginResponse), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .success(let code):
                self?.onSuccess?(code)
            case .error(let error):
                self?.showSnackbar(error ?? "")
            }
            ProgressView.instance.hide(animated: true)
        }
    }
    
    private func showSnackbar(_ text: String, lifeTimeDuration: TimeInterval = 2) {
        let options: Snackbar.AnimationOptions = .init(
            targetAnchor: .bottom(spacing: .value(-view.center.y - view.layoutMargins.bottom + 50)),
            source: .fromBottom,
            animationDuration: 0.6, lifetimeDuration: lifeTimeDuration)
        
        Snackbar.showAttached(to: view,
                                in: view,
                                title: text,
                                backgroundColor: UIColor.systemBlue,
                                actions: [],
                                options: options)
        
    }
}
