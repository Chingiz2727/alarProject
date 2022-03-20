import Core
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var data: Data
    
    init(coordinte: CLLocationCoordinate2D, data: Data) {
        self.coordinate = coordinte
        self.data = data
    }
}
