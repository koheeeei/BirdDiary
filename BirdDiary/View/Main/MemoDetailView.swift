import SwiftUI

struct MemoDetailView: View {
    var memo: Memo
    
    var body: some View {
        VStack {
            Text(memo.text)
                .font(.largeTitle)
                .padding()
            
            if let image = memo.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            }
        }
        .navigationTitle("メモ詳細")
    }
}

struct MemoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // サンプルの Memo インスタンスを作成
        let sampleMemo = Memo(text: "サンプルメモ", image: UIImage(systemName: "photo"))
        
        // プレビューに Memo を渡す
        MemoDetailView(memo: sampleMemo)
    }
}
