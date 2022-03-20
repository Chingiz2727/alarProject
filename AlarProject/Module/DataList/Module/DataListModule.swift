import Core

protocol DataListModule: Presentable {
    typealias OnDataSelect = ((Data)->Void)
    
    var onDataSelect: OnDataSelect? { get set }
}
