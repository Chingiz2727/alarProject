struct AuthModel: Codable {
    let code: String
    let status: AuthStatus
}

enum AuthStatus: String, Codable {
    case success = "ok"
    case error
}
