import PhotosUI
import SwiftUI

struct CameraView: View {
    let onClose: () -> Void
    let onPhotoCaptured: (Data) -> Void

    @State private var camera = CameraController()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isCapturing = false

    var body: some View {
        ZStack {
            cameraPreview
                .ignoresSafeArea()

            VStack {
                topControls
                Spacer()
                bottomControls
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 34)
        }
        .background(.black)
        .task {
            guard !Self.isRunningInPreview else { return }
            await camera.start()
        }
        .task(id: selectedPhotoItem) {
            guard let selectedPhotoItem else { return }

            if let data = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                onPhotoCaptured(data)
            }
        }
        .onDisappear {
            camera.stop()
        }
    }

    private var cameraPreview: some View {
        ZStack {
            if camera.isReady {
                CameraPreview(session: camera.session)
            } else {
                Color.black

                if let errorMessage = camera.errorMessage {
                    Text(errorMessage)
                        .font(NutriTypography.body)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(28)
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
        }
    }

    private var topControls: some View {
        HStack {
            NutriIconButton(
                title: "Close",
                systemImage: "xmark",
                action: onClose
            )

            Spacer()
        }
    }

    private var bottomControls: some View {
        HStack(alignment: .center) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Image(systemName: "photo")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(NutriColors.cameraControl)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Choose from Library")

            Spacer()

            Button(action: capturePhoto) {
                Circle()
                    .fill(.white)
                    .frame(width: 82, height: 82)
                    .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 6))
                    .overlay {
                        if isCapturing {
                            ProgressView()
                                .tint(NutriColors.olive)
                        }
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Take Photo")
            .disabled(isCapturing)

            Spacer()

            NutriIconButton(
                title: camera.isFlashEnabled ? "Turn Flash Off" : "Turn Flash On",
                systemImage: camera.isFlashEnabled ? "bolt.fill" : "bolt.slash",
                size: 50,
                action: { camera.toggleFlash() }
            )
        }
    }

    private func capturePhoto() {
        guard !isCapturing else { return }

        isCapturing = true

        Task { @MainActor in
            defer { isCapturing = false }

            if let data = try? await camera.capturePhoto() {
                onPhotoCaptured(data)
            }
        }
    }

    private static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

#Preview {
    CameraView(onClose: {}, onPhotoCaptured: { _ in })
}
