import SwiftUI

struct ResultsView: View {
    @Binding var estimates: [PrescriptionEstimate]

    var body: some View {
        NavigationStack {
            List {
                if estimates.isEmpty {
                    ContentUnavailableView("No estimates yet", systemImage: "eye.slash", description: Text("Run one of the tests."))
                } else {
                    ForEach(estimates) { est in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(est.eye.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text(est.method)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            if let s = est.sphere {
                                Text("Sphere: \(String(format: "%+.2f", s)) D")
                            }
                            if let c = est.cylinder, let a = est.axis {
                                Text("Cylinder: \(String(format: "%+.2f", c)) D @ \(a)°")
                            }
                            if let snellen = est.acuitySnellen {
                                Text("Acuity: \(snellen)")
                            }
                            Text(est.notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(est.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { estimates.remove(atOffsets: $0) }
                }
            }
            .navigationTitle("Estimates")
            .toolbar {
                if !estimates.isEmpty {
                    Button("Clear All", role: .destructive) {
                        estimates.removeAll()
                    }
                }
            }
        }
    }
}
