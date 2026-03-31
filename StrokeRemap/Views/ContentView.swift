import SwiftUI

struct ContentView: View {
    @EnvironmentObject var monitor: InputSourceMonitor
    @EnvironmentObject var remapper: KeyRemapper
    @EnvironmentObject var permission: PermissionManager

    var body: some View {
        Text(monitor.isActive ? "筆劃輸入法已啟用" : "筆劃輸入法已停用")

        Divider()

        if permission.isGranted {
            Toggle(
                isOn: Binding(
                    get: { remapper.isEnabled },
                    set: { remapper.setEnabled($0) }
                ),
                label: {
                    Label(
                        remapper.isEnabled ? "已啟用" : "已停用",
                        systemImage: remapper.isEnabled ? "eye" : "eye.slash"
                    )
                }
            )
        } else {
            Button(action: { permission.requestPermission() }) {
                Label("系統授權", systemImage: "exclamationmark.circle.fill")
            }
        }

        Picker(selection: $remapper.mode) {
            ForEach(KeyboardMode.allCases, id: \.self) { mode in
                Text(mode.label).tag(mode)
            }
        } label: {
            Label(
                title: { Text("鍵盤類型") },
                icon: {
                    Image(
                        systemName: remapper.mode == .letter
                            ? "characters.uppercase" : "numbers"
                    )
                }
            )
        }

        Divider()

        Button(role: .destructive, action: { NSApp.terminate(nil) }) {
            Label("退出", systemImage: "power")
        }
    }
}
