import AVFoundation
import Foundation
import PhotosUI
import SwiftUI

@MainActor
@Observable
final class CameraViewModel {
    var isCapturing = false

    private let camera = CameraController()

    var isReady: Bool {
        camera.isReady
    }

    var errorMessage: String? {
        camera.errorMessage
    }

    var isFlashEnabled: Bool {
        camera.isFlashEnabled
    }

    var cameraSession: AVCaptureSession {
        camera.session
    }

    func start() async {
        await camera.start()
    }

    func stop() {
        camera.stop()
    }

    func toggleFlash() {
        camera.toggleFlash()
    }

    func loadPhotoData(from item: PhotosPickerItem?) async -> Data? {
        guard let item else { return nil }

        return try? await item.loadTransferable(type: Data.self)
    }

    func capturePhotoData() async -> Data? {
        guard !isCapturing else { return nil }

        isCapturing = true
        defer { isCapturing = false }

        return try? await camera.capturePhoto()
    }
}
