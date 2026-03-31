import SwiftUI

@main
struct StrokeRemapApp: App {
    @StateObject private var monitor = InputSourceMonitor.shared
    @StateObject private var remapper = KeyRemapper.shared
    @StateObject private var permission = PermissionManager.shared

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(monitor)
                .environmentObject(remapper)
                .environmentObject(permission)
        } label: {
            Image(
                systemName: monitor.isActive
                    ? "keyboard.badge.eye" : "keyboard"
            )
        }.menuBarExtraStyle(.menu)
    }
}
