//
//  Bird.swift
//  BirdDiary
//
//  Created by KI on 2025/05/04.
//

import SwiftUI

struct Bird {
    let id = UUID()
    var branchId: Int?
    var isAtInitialPosition: Bool = true
    // 位置情報や移動履歴などもここに
}
