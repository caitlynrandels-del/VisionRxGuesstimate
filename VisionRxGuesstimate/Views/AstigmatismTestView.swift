import SwiftUI

struct AstigmatismTestView: View {
    @Binding var estimates: [PrescriptionEstimate]

    @State private var selectedEye: PrescriptionEstimate.Eye = .right
    @State private var selectedAngle: Int = 90
    @State private var result: String?

    private let angles = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165]

    var body: some View {
        VStack(spacing: 24) {
            Text("Astigmatism Fan")
                .font(.largeTitle)

            Text("Cover the other eye. Look at the lines and select the direction that appears sharpest / darkest.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 500)

            Picker("Eye", selection: $selectedEye) {
                ForEach(PrescriptionEstimate.Eye.allCases) { eye in
                    Text(eye.rawValue).tag(eye)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 420)

            ZStack {
                ForEach(angles, id: \.self) { angle in
                    Capsule()
                        .fill(selectedAngle == angle ? Color.accentColor : Color.primary.opacity(0.7))
                        .frame(width: 5, height: 220)
                        .rotationEffect(.degrees(Double(angle)))
                        .onTapGesture { selectedAngle = angle }
                }
                Circle()
                    .fill(Color.secondary.opacity(0.4))
                    .frame(width: 16, height: 16)
            }
            .frame(height: 280)

            Text("Sharpest meridian: \(selectedAngle)°")
                .font(.title3)

            Button("Save Axis Estimate") {
                save()
            }
            .buttonStyle(.borderedProminent)

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
        // Cylinder magnitude remains hard to estimate from a fan alone
        let roughCyl = -0.75

        result = """
        \(selectedEye.rawValue) eye
        Rough axis: \(selectedAngle)°
        Rough cylinder: \(String(format: "%+.2f", roughCyl)) D
        (Magnitude is a placeholder — fan charts mainly help with axis.)
        """

        if let index = estimates.lastIndex(where: { $0.eye == selectedEye }) {
            estimates[index].cylinder = roughCyl
            estimates[index].axis = selectedAngle
            estimates[index].notes += " + Fan chart axis."
        } else {
            estimates.append(PrescriptionEstimate(
                eye: selectedEye,
                sphere: nil,
                cylinder: roughCyl,
                axis: selectedAngle,
                acuitySnellen: nil,
                acuityLogMAR: nil,
                method: "Fan chart",
                notes: "Rough axis from fan chart. Cylinder magnitude not reliably measured."
            ))
        }
    }
}
