import AppKit
import ApplicationServices
import Combine
import Foundation

private func tapCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    refcon: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let refcon else { return Unmanaged.passRetained(event) }
    let r = Unmanaged<KeyRemapper>.fromOpaque(refcon).takeUnretainedValue()

    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = r.eventTap {
            CGEvent.tapEnable(tap: tap, enable: true)
            if !CGEvent.tapIsEnabled(tap: tap) {
                DispatchQueue.main.async { r.isEnabled = false }
            }
        }
        return Unmanaged.passRetained(event)
    }

    guard r.isEnabled,
        type == .keyDown || type == .keyUp,
        InputSourceMonitor.shared.isActive
    else { return Unmanaged.passRetained(event) }

    let kc = event.getIntegerValueField(.keyboardEventKeycode)
    if let mapped = r.mode.swapMap[kc] {
        event.setIntegerValueField(.keyboardEventKeycode, value: mapped)
    }
    return Unmanaged.passRetained(event)
}

class KeyRemapper: ObservableObject {
    static let shared = KeyRemapper()

    @Published var isEnabled: Bool = false
    @Published var mode: KeyboardMode = .letter

    var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    private init() {}

    func setEnabled(_ value: Bool) {
        if value {
            guard PermissionManager.shared.isGranted else {
                PermissionManager.shared.requestPermission()
                return
            }
            if eventTap == nil { createTap() }
            if let tap = eventTap { CGEvent.tapEnable(tap: tap, enable: true) }
            isEnabled = true
        } else {
            if let tap = eventTap { CGEvent.tapEnable(tap: tap, enable: false) }
            isEnabled = false
        }
    }

    private func createTap() {
        let refcon = Unmanaged.passRetained(self).toOpaque()
        let mask = CGEventMask(
            (1 << CGEventType.keyDown.rawValue)
                | (1 << CGEventType.keyUp.rawValue)
        )
        guard
            let tap = CGEvent.tapCreate(
                tap: .cghidEventTap,
                place: .headInsertEventTap,
                options: .defaultTap,
                eventsOfInterest: mask,
                callback: tapCallback,
                userInfo: refcon
            )
        else { return }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(
            kCFAllocatorDefault,
            tap,
            0
        )
        if let src = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetMain(), src, .commonModes)
        }
    }
}
