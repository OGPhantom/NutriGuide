import PhotosUI
import SwiftUI

struct CameraView: View {
    let onClose: () -> Void
    let onPhotoCaptured: (Data) -> Void

    @State private var viewModel = CameraViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        @Bindable var viewModel = viewModel

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
            await viewModel.start()
        }
        .task(id: selectedPhotoItem) {
            if let data = await viewModel.loadPhotoData(from: selectedPhotoItem) {
                selectedPhotoItem = nil
                onPhotoCaptured(data)
            }
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    private var cameraPreview: some View {
        ZStack {
            if viewModel.isReady {
                CameraPreview(session: viewModel.cameraSession)
            } else {
                Color.black

                if let errorMessage = viewModel.errorMessage {
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
        let cameraControl = NutriColors.cameraControl

        return HStack(alignment: .center) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Image(systemName: "photo")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(cameraControl)
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
                        if viewModel.isCapturing {
                            ProgressView()
                                .tint(NutriColors.olive)
                        }
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Take Photo")
            .disabled(viewModel.isCapturing)

            Spacer()

            NutriIconButton(
                title: viewModel.isFlashEnabled ? "Turn Flash Off" : "Turn Flash On",
                systemImage: viewModel.isFlashEnabled ? "bolt.fill" : "bolt.slash",
                size: 50,
                action: { viewModel.toggleFlash() }
            )
        }
    }

    private func capturePhoto() {
        Task { @MainActor in
            if let data = await viewModel.capturePhotoData() {
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
