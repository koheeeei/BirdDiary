import SwiftUI

class MemoViewModel: ObservableObject {
    @Published var memos: [Memo] = []
    
    // メモを追加するメソッド
    func addMemo(text: String, image: UIImage? = nil) {
        let newMemo = Memo(text: text, image: image)
        memos.append(newMemo)
    }
}
