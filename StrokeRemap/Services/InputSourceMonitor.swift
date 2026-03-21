import Carbon
import Combine
import Foundation

class InputSourceMonitor: ObservableObject {
    static let shared = InputSourceMonitor()

    @Published var isActive: Bool = false
    @Published var currentSourceID: String = "—"

    private let strokeIDs: Set<String> = [
        "com.apple.inputmethod.TCIM.WBH",
        "com.apple.inputmethod.SCIM.WBH",
        "com.apple.inputmethod.TYIM.WBH",
        "com.apple.inputmethod.TCIM.Stroke",
        "com.apple.inputmethod.SCIM.Stroke",
        "com.apple.inputmethod.TYIM.Stroke",
    ]

    private init() {
        refresh()

        let observer = Unmanaged.passRetained(self).toOpaque()

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDistributedCenter(),
            observer,
            { _, ptr, _, _, _ in
                guard let ptr else { return }
                Unmanaged<InputSourceMonitor>.fromOpaque(ptr)
                    .takeUnretainedValue().refresh()
            },
            kTISNotifySelectedKeyboardInputSourceChanged,
            nil,
            .deliverImmediately
        )
    }

    func refresh() {
        let source = TISCopyCurrentKeyboardInputSource().takeRetainedValue()

        guard
            let ptr = TISGetInputSourceProperty(
                source,
                kTISPropertyInputSourceID
            )
        else { return }

        let id =
            Unmanaged<CFString>.fromOpaque(ptr).takeUnretainedValue() as String

        DispatchQueue.main.async {
            self.currentSourceID = id
            self.isActive = self.strokeIDs.contains(id)
        }
    }
}
