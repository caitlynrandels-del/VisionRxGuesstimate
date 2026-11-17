import SwiftUI

struct LandoltCShape: Shape {
    var gapAngle: Angle = .degrees(0)
    var gapWidth: Double = 0.18

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = gapAngle.radians - gapWidth
        let end = gapAngle.radians + gapWidth

        path.addArc(center: center, radius: radius, startAngle: Angle(radians: end), endAngle: Angle(radians: start + 2 * .pi), clockwise: false)
        return path
    }
}

struct AcuityTestView: View {
    @Binding var estimates: [PrescriptionEstimate]

    @State private var selectedEye: PrescriptionEstimate.Eye = .right
    @State private var isRunning = false
    @State private var currentSize: CGFloat = 160
    @State private var orientation: Int = 0
    @State private var trial = 0
    @State private var correct = 0
    @State private var feedback = ""
    @State private var finishedResult: String?

    private let totalTrials = 10
    private let sizes: [CGFloat] = [180, 140, 110, 85, 65, 50, 40, 32, 26, 22]

    var body: some View {
        VStack(spacing: 24) {
            Text("Acuity Test")
                .font(.largeTitle)

            Picker("Eye", selection: $selectedEye) {
                ForEach(PrescriptionEstimate.Eye.allCases) { eye in
                    Text(eye.rawValue).tag(eye)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 420)
            .disabled(isRunning)

            if !isRunning {
                Button("Start \(selectedEye.rawValue) Eye Test") {
                    start()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else {
                Text("Which way is the gap?")
                    .font(.title2)

                LandoltCShape(gapAngle: .degrees(Double(orientation) * 90))
                    .stroke(lineWidth: max(6, currentSize * 0.12))
                    .frame(width: currentSize, height: currentSize)
                    .padding(20)

                HStack(spacing: 16) {
                    directionButton("↑", 0)
                    directionButton("→", 1)
                    directionButton("↓", 2)
                    directionButton("←", 3)
                }

                Text("Trial \(trial + 1) of \(totalTrials)")
                    .foregroundStyle(.secondary)
            }

            if let finishedResult {
                Text(finishedResult)
                    .font(.title3)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Spacer()
        }
        .padding()
    }

    private func directionButton(_ title: String, _ dir: Int) -> some View {
        Button(title) {
            answer(dir)
        }
        .font(.title)
        .frame(width: 88, height: 72)
        .background(.blue.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .hoverEffect()
    }

    private func start() {
        isRunning = true
        trial = 0
        correct = 0
        finishedResult = nil
        nextStimulus()
    }

    private func nextStimulus() {
        orientation = Int.random(in: 0...3)
        currentSize = sizes[min(trial, sizes.count - 1)]
    }

    private func answer(_ chosen: Int) {
        if chosen == orientation { correct += 1 }
        trial += 1
        if trial >= totalTrials {
            finish()
        } else {
            nextStimulus()
        }
    }

    private func finish() {
        isRunning = false
        let accuracy = Double(correct) / Double(totalTrials)
        let sizeIndex = min(trial - 1, sizes.count - 1)
        let lastSize = sizes[max(0, sizeIndex)]

        // Rough mapping (demo heuristic)
        let snellen: String
        let logMAR: Double
        let sphere: Double

        switch lastSize {
        case 180...: snellen = "20/200"; logMAR = 1.0; sphere = -2.50
        case 140..<180: snellen = "20/100"; logMAR = 0.7; sphere = -1.75
        case 110..<140: snellen = "20/70"; logMAR = 0.54; sphere = -1.25
        case 85..<110: snellen = "20/50"; logMAR = 0.4; sphere = -1.00
        case 65..<85: snellen = "20/40"; logMAR = 0.3; sphere = -0.75
        case 50..<65: snellen = "20/30"; logMAR = 0.18; sphere = -0.50
        case 40..<50: snellen = "20/25"; logMAR = 0.1; sphere = -0.25
        default: snellen = "20/20"; logMAR = 0.0; sphere = 0.0
        }

        let adjustedSphere = sphere * (0.7 + accuracy * 0.3)

        finishedResult = """
        \(selectedEye.rawValue) eye
        Acuity: \(snellen)  (logMAR ≈ \(String(format: "%.2f", logMAR)))
        Rough sphere: \(String(format: "%+.2f", adjustedSphere)) D
        Correct: \(correct)/\(totalTrials)
        """

        estimates.append(PrescriptionEstimate(
            eye: selectedEye,
            sphere: adjustedSphere,
            cylinder: nil,
            axis: nil,
            acuitySnellen: snellen,
            acuityLogMAR: logMAR,
            method: "Landolt C threshold",
            notes: "Rough acuity-based sphere estimate. Not clinical."
        ))
    }
}
