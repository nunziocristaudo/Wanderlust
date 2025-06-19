import Foundation

final class PinService {
    private let fileURL: URL
    private var cachedPins: [Pin] = []

    init(filename: String = "pins.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documents.appendingPathComponent(filename)
        self.cachedPins = loadPins()
    }

    func getPins() -> [Pin] {
        cachedPins
    }

    func addPin(_ pin: Pin) {
        cachedPins.append(pin)
        savePins()
    }

    private func savePins() {
        do {
            let data = try JSONEncoder().encode(cachedPins)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save pins: \(error)")
        }
    }

    private func loadPins() -> [Pin] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Pin].self, from: data)
        } catch {
            print("Failed to load pins: \(error)")
            return []
        }
    }
}
