import UIKit
import MapboxMaps

class MapViewController: UIViewController {
    private var mapView: MapView!
    private let pinService = PinService()
    private var annotationManager: PointAnnotationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupGestures()
        loadSavedPins()
    }

    private func setupMap() {
        guard let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"),
              let mbtilesURL = Bundle.main.url(forResource: "brisbane", withExtension: "mbtiles") else {
            fatalError("Missing offline resources")
        }

        var resourceOptions = ResourceOptions(accessToken: "")
        resourceOptions.tileStoreConfiguration = TileStoreConfiguration(tileURL: mbtilesURL)
        let initOptions = MapInitOptions(resourceOptions: resourceOptions, styleURI: .init(url: styleURL))
        mapView = MapView(frame: view.bounds, mapInitOptions: initOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        annotationManager = mapView.annotations.makePointAnnotationManager()
    }

    private func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: point)
        presentCategorySelection(at: coordinate)
    }

    private func presentCategorySelection(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "Pin Category", message: "Choose a category", preferredStyle: .actionSheet)
        for category in PinCategory.allCases {
            alert.addAction(UIAlertAction(title: category.rawValue.capitalized, style: .default) { _ in
                self.createPin(at: coordinate, category: category)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func createPin(at coordinate: CLLocationCoordinate2D, category: PinCategory) {
        let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, category: category)
        pinService.addPin(pin)
        addAnnotation(for: pin)
    }

    private func addAnnotation(for pin: Pin) {
        guard let annotationManager else { return }
        var annotation = PointAnnotation(coordinate: pin.coordinate)
        annotation.image = .init(image: markerImage(colorHex: pin.category.colorHex), name: pin.category.rawValue)
        annotationManager.annotations.append(annotation)
    }

    private func loadSavedPins() {
        for pin in pinService.getPins() {
            addAnnotation(for: pin)
        }
    }

    private func markerImage(colorHex: String) -> UIImage {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor(hex: colorHex).cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

private extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
