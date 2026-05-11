import Foundation
@preconcurrency import AVFoundation
import UIKit

enum CameraControllerError: LocalizedError {
    case accessDenied
    case missingDevice
    case setupFailed
    case captureFailed

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            "Camera access is required to scan a meal."
        case .missingDevice:
            "No camera device is available."
        case .setupFailed:
            "The camera could not be started."
        case .captureFailed:
            "The photo could not be captured."
        }
    }
}

@MainActor
@Observable
final class CameraController: NSObject {
    let session = AVCaptureSession()
    var isReady = false
    var errorMessage: String?
    var isFlashEnabled = false

    private let sessionQueue = DispatchQueue(label: "NutriGuide.camera.session")
    private let output = AVCapturePhotoOutput()
    private var captureContinuation: CheckedContinuation<Data, Error>?

    func start() async {
        do {
            try await requestAccessIfNeeded()
            try await configureIfNeeded()
            await startSessionIfNeeded()
            isReady = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func stop() {
        sessionQueue.async { [session] in
            guard session.isRunning else { return }
            session.stopRunning()
        }
    }

    func toggleFlash() {
        isFlashEnabled.toggle()
    }

    func capturePhoto() async throws -> Data {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
            captureContinuation = continuation

            let settings = AVCapturePhotoSettings()
            if output.supportedFlashModes.contains(.on) {
                settings.flashMode = isFlashEnabled ? .on : .off
            }

            output.capturePhoto(with: settings, delegate: self)
        }
    }

    private func requestAccessIfNeeded() async throws {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            let granted = await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }

            if !granted {
                throw CameraControllerError.accessDenied
            }
        default:
            throw CameraControllerError.accessDenied
        }
    }

    private func configureIfNeeded() async throws {
        guard session.inputs.isEmpty else { return }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            sessionQueue.async { [session, output] in
                do {
                    session.beginConfiguration()
                    session.sessionPreset = .photo

                    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                        session.commitConfiguration()
                        continuation.resume(throwing: CameraControllerError.missingDevice)
                        return
                    }

                    let input = try AVCaptureDeviceInput(device: device)

                    guard session.canAddInput(input), session.canAddOutput(output) else {
                        session.commitConfiguration()
                        continuation.resume(throwing: CameraControllerError.setupFailed)
                        return
                    }

                    session.addInput(input)
                    session.addOutput(output)
                    session.commitConfiguration()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func startSessionIfNeeded() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            sessionQueue.async { [session] in
                if !session.isRunning {
                    session.startRunning()
                }

                continuation.resume()
            }
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        Task { @MainActor in
            if let error {
                captureContinuation?.resume(throwing: error)
                captureContinuation = nil
                return
            }

            guard let data = photo.fileDataRepresentation() else {
                captureContinuation?.resume(throwing: CameraControllerError.captureFailed)
                captureContinuation = nil
                return
            }

            captureContinuation?.resume(returning: data)
            captureContinuation = nil
        }
    }
}
