import Alamofire

public enum Route: RouteProtocol {
    case login(userName: String, password: String)
    case getData(code: String, page: Int, size: Int)
    
    public var rawValue: String {
        switch self {
        case .login(let userName, let password):
            return "test/auth.cgi"
        case .getData(let code, let page, let size):
            return "test/data.cgi"
        }
    }
    
    public var serverUrl: String {
        return "https://www.alarstudios.com/"
    }
}
