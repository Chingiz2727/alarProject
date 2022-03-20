import UIKit
import Core

typealias CardDataCell = CardDataTile & UICollectionViewCell

protocol CardDataTile: class {
    
}

protocol CardDataCellFactory {
    func makeCell(from item: Data, in collection: UICollectionView, indexPath: IndexPath) -> CardDataCollectionViewCell
}

class CardDataTileFactory: CardDataCellFactory {
    private var registerCells: Set<String> = []
    
    private func registerIfNeeded<T: UICollectionViewCell>(_ cellType: T.Type, collectionView: UICollectionView) {
        if !registerCells.contains(cellType.typeName) {
            collectionView.register(cellType, forCellWithReuseIdentifier: cellType.typeName)
            registerCells.insert(cellType.typeName)
        }
    }
    
    func makeCell(from item: Data, in collection: UICollectionView, indexPath: IndexPath) -> CardDataCollectionViewCell {
        registerIfNeeded(CardDataCollectionViewCell.self, collectionView: collection)
        let cell = collection.dequeueReusableCell(withReuseIdentifier: CardDataCollectionViewCell.typeName, for: indexPath) as! CardDataCollectionViewCell
        cell.setData(data: item)
//        cell.setCardData(card: item)
        return cell
    }
}
