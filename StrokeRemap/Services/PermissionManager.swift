import AppKit
import ApplicationServices
import Combine

class PermissionManager: ObservableObject {
    static let shared = PermissionManager()

    @Published var isGranted: Bool = false

    private var pollTimer: Timer?

    private init() {
        isGranted = AXIsProcessTrusted()
        if !isGranted { startPolling() }
    }

    func requestPermission() {
        let opts =
            [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
            as CFDictionary
        AXIsProcessTrustedWithOptions(opts)
        if !isGranted { startPolling() }
    }

    private func startPolling() {
        guard pollTimer == nil else { return }
        pollTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] timer in
            guard let self else { timer.invalidate(); return }
            let granted = AXIsProcessTrusted()
            if granted {
                DispatchQueue.main.async { self.isGranted = true }
                timer.invalidate()
                self.pollTimer = nil
            }
        }
    }
}
