import MapKit
import Core

final class MapViewModel: NSObject, MapFactory {
    typealias MapView = MKMapView

    var onAnnotationDidTap: ((Any?) -> Void)?
    
    func setAnnotation(in mapView: MKMapView, point: MapPoint, image: UIImage?, associatedData: Any?) {
        setAnnotationAtMap(in: mapView, point: point, image: image, associatedData: associatedData)
    }
    
    func moveTo(in view: MKMapView, point: MapPoint, completionHandler: VoidBlock?) {
        moveToSpecificLocation(in: view, point: point, completionHandler: completionHandler)
    }
    
    func showCurrentLocation(in view: MKMapView) {
        
    }
    
    private func setAnnotationAtMap(in mapView: MapView, point: MapPoint, image: UIImage?, associatedData: Any?) {
        guard let associatedData = associatedData as? Data else {
            return
        }
        let view = MKAnnotationView()
        let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        let annotation = MapAnnotation(coordinte: coordinate, data: associatedData)
        view.image = image
        view.annotation = annotation
        mapView.addAnnotation(view.annotation!)
    }
    
    private func moveToSpecificLocation(in mapView: MapView, point: MapPoint, completionHandler: VoidBlock?) {
        let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        mapView.setCenter(coordinate, animated: true)
    }
    
    func setMapListener(in mapView: MKMapView) {
        mapView.delegate = self
    }
}

extension MapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        onAnnotationDidTap?(view.annotation)
    }
}
