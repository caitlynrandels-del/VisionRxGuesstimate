import SwiftUI

struct ContentView: View {
    @State private var estimates: [PrescriptionEstimate] = []
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DisclaimerView()
                .tabItem { Label("Start", systemImage: "info.circle") }
                .tag(0)

            AcuityTestView(estimates: $estimates)
                .tabItem { Label("Acuity", systemImage: "eye") }
                .tag(1)

            BlurMatchingView(estimates: $estimates)
                .tabItem { Label("Blur Match", systemImage: "slider.horizontal.3") }
                .tag(2)

            AstigmatismTestView(estimates: $estimates)
                .tabItem { Label("Astigmatism", systemImage: "circle.grid.cross") }
                .tag(3)

            ResultsView(estimates: $estimates)
                .tabItem { Label("Results", systemImage: "list.bullet.clipboard") }
                .tag(4)
        }
    }
}

struct DisclaimerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("VisionRx Guesstimate")
                    .font(.extraLargeTitle2)

                Text("Rough prescription approximation for Apple Vision Pro")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("This tool uses only the Vision Pro display and your responses. It is for rough guesstimation only.")
                    .padding(.top, 8)

                GroupBox("Tests included") {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Acuity Test — Landolt C threshold for rough sphere + Snellen", systemImage: "eye")
                        Label("Blur Match — adjust digital defocus until it matches your uncorrected vision", systemImage: "slider.horizontal.3")
                        Label("Astigmatism Fan — pick sharpest meridian for rough axis", systemImage: "circle.grid.cross")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text("All interaction works with gaze + pinch or on-screen controls. Results stay on device.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding(24)
        }
    }
}
