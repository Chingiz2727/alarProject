import Core

final class DataListSectionViewModel: PaginatedBaseFeedSectionViewModel<Data> {
    
    init(code: String, sectionControllerBuilder:SectionControllerBuilder?) {
        
        super.init(sectionControllerBuilder: sectionControllerBuilder) { cachePolicy, onUpdate -> PaginatedDataProvider<Data> in
            return DataListDataProvider(code: code, cachePolicy: cachePolicy, onUpdate: onUpdate)
        }
    }
    
    override func loadNext() {
        dataProvider?.loadNext()
    }
}
