import SwiftUI

struct BlurMatchingView: View {
    @Binding var estimates: [PrescriptionEstimate]

    @State private var selectedEye: PrescriptionEstimate.Eye = .right
    @State private var blurRadius: CGFloat = 0
    @State private var referenceText = "E F P T O Z"
    @State private var result: String?

    var body: some View {
        VStack(spacing: 28) {
            Text("Blur Match")
                .font(.largeTitle)

            Text("Adjust the blur until the letters look as sharp (or as blurry) as your uncorrected vision for the selected eye.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 520)

            Picker("Eye", selection: $selectedEye) {
                ForEach(PrescriptionEstimate.Eye.allCases) { eye in
                    Text(eye.rawValue).tag(eye)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 420)

            Text(referenceText)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .blur(radius: blurRadius)
                .frame(height: 100)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack {
                Slider(value: $blurRadius, in: 0...18, step: 0.25)
                    .frame(maxWidth: 480)
                Text("Blur radius: \(String(format: "%.1f", blurRadius))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button("Save Estimate") {
                save()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if let result {
                Text(result)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
        }
        .padding()
    }

    private func save() {
        // Rough conversion: blur radius → approximate diopters (demo only)
        // Higher blur ≈ stronger uncorrected power
        let estimatedSphere = -Double(blurRadius) * 0.18

        result = """
        \(selectedEye.rawValue) eye
        Matched blur: \(String(format: "%.1f", blurRadius))
        Rough sphere: \(String(format: "%+.2f", estimatedSphere)) D
        """

        estimates.append(PrescriptionEstimate(
            eye: selectedEye,
            sphere: estimatedSphere,
            cylinder: nil,
            axis: nil,
            acuitySnellen: nil,
            acuityLogMAR: nil,
            method: "Digital blur match",
            notes: "User matched digital blur to uncorrected vision. Heuristic conversion only."
        ))
    }
}
