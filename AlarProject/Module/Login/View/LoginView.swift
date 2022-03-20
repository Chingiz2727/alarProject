import UIKit
import SnapKit
import CoreUI

private enum Constants {
    static let textFieldHeight: CGFloat = 55
    static let buttonHeight: CGFloat = 44
}
final class LoginView: UIView {
    
    let usernameTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Логин"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Логин", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "Авторизация"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, sendButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func configureView() {
        backgroundColor = .white
    }
}
