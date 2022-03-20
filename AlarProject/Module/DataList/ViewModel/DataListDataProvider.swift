import Foundation
import Core

final class DataListDataProvider: PaginatedDataProvider<Data> {
    typealias State = PaginatedDataProviderState<Data>
    let code: String
    private let networkService: NetworkService = Resolver.resolve()
    
    init(code: String, limit: Int = 10, cachePolicy: APICachePolicy, onUpdate: @escaping (State) -> Void) {
        self.code = code
        super.init(limit: limit, startOffset: 1, cachePolicy: cachePolicy, maxAttemptsCount: 5, onUpdate: onUpdate)
    }
    
    
    override func makeRequest(resultHandler: @escaping (Result<State, Error>) -> Void) -> DataProviderRequest {
        let limit = self.limit
        return DataProviderRequest{ [weak self] offset -> APITask? in
            guard let self = self else { return nil }
            return self.paginatedRequest(page: offset/limit, code: self.code, offSet: limit, resultHandler: resultHandler)
        }
    }
    
    private func paginatedRequest(page: Int, code: String, offSet: Int, resultHandler: @escaping (Result<State, Error>) -> Void) -> APITask? {
        let context = AppNetworkContext.tableData(code: code, page: page, size: offSet)
        return networkService.load(context: context) { response  in
            var newState = self.state
            guard response.isSuccess  else {
                newState.loadingState = .error
                resultHandler(.failure(NetworkError.unknown))
                return
            }
            
            guard let statement: DataItem = response.decode() else {
                resultHandler(.failure(NetworkError.dataLoad))
                return
            }
            print("[PicksOfFollowedUsersDataProvider] will load with offset \(offSet), limit: \(page)")

            self.handleItemsHelper(statement.data, offset: offSet, error: response.networkError, source: .server, result: resultHandler)
        }
    }
}
