import SwiftUI

struct MemoPopup: View {
    @ObservedObject var viewModel: MemoViewModel
    @State private var memoText = ""
    @State private var selectedImage: UIImage? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("メモを入力")
                .font(.headline)
            
            TextField("ここにメモを入力", text: $memoText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("写真を追加") {
                showImagePicker = true
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            Button("保存") {
                viewModel.addMemo(text: memoText, image: selectedImage)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}


// プレビュー用の MemoViewModel のモック
class MockMemoViewModel: MemoViewModel {
    override func addMemo(text: String, image: UIImage? = nil) {
        // 何もしない（モック）
    }
}

struct MemoPopup_Previews: PreviewProvider {
    static var previews: some View {
        // モックの ViewModel を使ったプレビュー
        MemoPopup(viewModel: MockMemoViewModel())
            .previewLayout(.sizeThatFits) // プレビューサイズの調整
    }
}
