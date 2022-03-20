import UIKit
import Core
import CoreUI

final class MapViewController: UIViewController, MapModule, ViewOwner {
    typealias RootView = MapView
    
    private let data: Data
    private let viewModel: MapManager<MapViewModel>
    
    init(data: Data, viewModel: MapManager<MapViewModel>) {
        self.data = data
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }
    
    private func configureMapView() {
        viewModel.setMapListener(in: rootView.mapView)
        let point = MapPoint(latitude: data.lat, longitude: data.lon)
        viewModel.createAnnotation(in: rootView.mapView, point: point, image: nil, associatedData: data)
        viewModel.moveTo(in: rootView.mapView, point: point, completionHandler: nil)
        viewModel.onAnnotationDidTap = { [weak self] data in
            guard let mapAnnotation = data as? MapAnnotation else { return }
            self?.showInfoAlert(data: mapAnnotation.data)
        }
    }
    
    private func showInfoAlert(data: Data) {
        let alert = UIAlertController(title: data.country, message: data.name, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
