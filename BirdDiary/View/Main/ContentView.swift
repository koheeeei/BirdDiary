//
//  ContentView.swift
//  BirdDiary
//
//  Created by KI on 2024/10/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MemoViewModel()
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("テストメモを追加!!") {
                    showPopup.toggle()
                }
                .padding()
                .sheet(isPresented: $showPopup) {
                    MemoPopup(viewModel: viewModel)
                }
                
                // メモのリストを表示
                List(viewModel.memos) { memo in
                    NavigationLink(destination: MemoDetailView(memo: memo)) {
                        HStack {
                            if let image = memo.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            Text(memo.text)
                                .lineLimit(1)
                        }
                    }
                }
                
                .navigationTitle("メモ一覧")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .imageScale(.large)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: BirdView().ignoresSafeArea()) {
                            Image(systemName: "square.stack.3d.down.right.fill")
                                .imageScale(.large)
                            
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: Bird2View().ignoresSafeArea()) {
                            Image(systemName: "square.stack.3d.down.right")
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
