import Core

enum AppNetworkContext: NetworkContext {

    case login(userName: String, password: String)
    case tableData(code: String, page: Int, size: Int)
    
    var route: Route {
        switch self {
        case let.login(userName, password):
            return .login(userName: userName, password: password)
        case let.tableData(code, page, size):
            return .getData(code: code, page: page, size: size)
        }
    }
    
    var method: NetworkMethod {
        return .get
    }
    
    var parameters: [String : Any] {
        switch self {
        case .login(let userName, let password):
            return ["username": userName, "password": password]
        case .tableData(let code, let page, let size):
            return ["code":code, "p":page, "size": size]
        }
    }
    var encoding: NetworkEncoding {
        switch self {
        case .login:
            return .urlStringEncoding
        case .tableData:
            return .url
        }
    }
}
