import Foundation
import CoreLocation

enum PinCategory: String, Codable, CaseIterable {
    case food
    case photo
    case trail
    case other

    var colorHex: String {
        switch self {
        case .food: return "#ff6347" // tomato
        case .photo: return "#4169e1" // royal blue
        case .trail: return "#32cd32" // lime green
        case .other: return "#ffd700" // gold
        }
    }
}

struct Pin: Codable, Identifiable {
    let id: UUID
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    var category: PinCategory

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, category: PinCategory) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
