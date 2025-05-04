//
//  Bird.swift
//  BirdDiary
//
//  Created by KI on 2025/05/04.
//

import SwiftUI

struct Branch {
    var id: Int
    var position: CGPoint
    var size: CGSize
    var availablePositions: [CGPoint]
    var imageName: String
    
    // 枝の初期化
    init(id: Int, position: CGPoint, size: CGSize, availablePositions: [CGPoint]) {
        self.id = id
        self.position = position
        self.size = size
        self.availablePositions = availablePositions
        self.imageName = "branch_\(id)"
    }
    
    // 枝の状態を変更するメソッド（例: 枝の位置を変更）
    mutating func updatePosition(to newPosition: CGPoint) {
        self.position = newPosition
    }
    
    // 枝の座標を取得するメソッド（オプション）
    func getPosition(at index: Int) -> CGPoint? {
        guard index >= 0 && index < availablePositions.count else {
            return nil
        }
        return availablePositions[index]
    }
}
