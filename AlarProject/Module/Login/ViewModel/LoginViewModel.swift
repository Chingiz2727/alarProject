import Core

protocol LoginViewModel {
    typealias AuthorizationState = ((AuthState)->Void)
    var onStateChanged: AuthorizationState? { get set }
    func makeLogin(userName: String, password: String)
}

final class LoginViewModelImpl: LoginViewModel {
    private let service = Resolver.resolve(NetworkService.self)
    var onStateChanged: AuthorizationState?
    
    func makeLogin(userName: String, password: String) {
        let context = AppNetworkContext.login(userName: userName, password: password)
        service.load(context: context) { [weak self] response in
            guard let authModel: AuthModel = response.decode() else {
                self?.onStateChanged?(.error(error: response.networkError?.localizedDescription))
                return
            }
            switch authModel.status {
            case .success:
                self?.onStateChanged?(.success(code: authModel.code))
            case .error:
                self?.onStateChanged?(.error(error: NetworkError.unauthorized.description))
            }
        }
    }
}

enum AuthState {
    case success(code: String)
    case error(error: String?)
}
