import SwiftUI

struct SettingsView: View {
    // 通知設定：永続化するためにAppStorageを使用
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    // テーマ設定：永続化とテーマの適用
    @AppStorage("selectedTheme") private var selectedTheme: String = "light"
    @Environment(\.colorScheme) private var colorScheme
    @State private var appTheme: ColorScheme? = nil
    
    // データリセットのためのアラート表示
    @State private var resetDataConfirmation = false
    
    // テーマ選択肢
    let themes = ["ライトモード", "ダークモード", "システム設定に合わせる"]
    
    var body: some View {
        NavigationView {
            Form {
                // 通知設定
                Section(header: Text("通知設定")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("通知を有効にする")
                    }
                }
                
                // テーマ設定
                Section(header: Text("テーマ設定")) {
                    Picker("テーマを選択", selection: $selectedTheme) {
                        Text("ライトモード").tag("light")
                        Text("ダークモード").tag("dark")
                    }
                    .pickerStyle(SegmentedPickerStyle())
//                    .padding()
                }
                
                // データリセット
                Section(header: Text("データ管理")) {
                    Button(action: {
                        resetDataConfirmation = true
                    }) {
                        Text("データをリセット")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $resetDataConfirmation) {
                        Alert(
                            title: Text("データのリセット"),
                            message: Text("すべてのデータを削除します。よろしいですか？"),
                            primaryButton: .destructive(Text("リセット")) {
                                resetUserData()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationTitle("設定")
            .preferredColorScheme(appTheme)
            .onAppear {
                updateTheme() // 初回表示時にテーマを反映
            }
        }
    }
    
    // テーマを更新する関数
    private func updateTheme() {
        switch selectedTheme {
        case "ライトモード":
            appTheme = .light
        case "ダークモード":
            appTheme = .dark
        default:
            appTheme = nil // システム設定に従う
        }
    }
    
    // ユーザーデータをリセットする関数
    private func resetUserData() {
        // ここでは、UserDefaults全体を削除する簡単な例
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        // その後、必要に応じてデフォルト設定を再設定
        notificationsEnabled = false
        selectedTheme = "システム設定に合わせる"
    }
}


#Preview {
    SettingsView()
}
