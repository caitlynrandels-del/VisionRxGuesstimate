import Foundation

struct PrescriptionEstimate: Identifiable, Codable {
    let id = UUID()
    var eye: Eye
    var sphere: Double?
    var cylinder: Double?
    var axis: Int?
    var acuitySnellen: String?
    var acuityLogMAR: Double?
    var method: String
    var notes: String
    var timestamp: Date = Date()

    enum Eye: String, Codable, CaseIterable, Identifiable {
        case left = "Left"
        case right = "Right"
        case both = "Both"
        var id: String { rawValue }
    }
}
