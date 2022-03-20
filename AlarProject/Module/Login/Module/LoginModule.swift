import Core

protocol LoginModule: Presentable {
    typealias OnSuccess = ((String)->Void)
    
    var onSuccess: OnSuccess? { get set }
}
