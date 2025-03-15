//
//  GameScene.swift
//  fdfa
//
//  Created by KI on 2024/11/23.
//

import Foundation
import SpriteKit

class BirdScene: SKScene {
    
    var birds: [SKSpriteNode] = [] // 複数の鳥ノードを管理する配列
    var movementDirections: [SKSpriteNode: CGVector] = [:] // 各ノードの移動方向を管理
    
    override func didMove(to view: SKView) {
        for i in 0..<5 { // SKSに配置した鳥ノードの数
            if let bird = self.childNode(withName: "bird_\(i)") as? SKSpriteNode {
                birds.append(bird)
                movementDirections[bird] = randomDirectionVector()
                startContinuousMovement(for: bird)
                scheduleRandomDirectionChange(for: bird)
            }
        }
    }
    
    // ランダムな方向ベクトルを生成
    func randomDirectionVector() -> CGVector {
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let speed: CGFloat = 200 // 速度の大きさを固定
        return CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
    }
    
    // 各ノードに独立した動きを設定する
    func startContinuousMovement(for bird: SKSpriteNode) {
        let updateAction = SKAction.run { [weak self] in
            self?.updatePosition(for: bird)
        }
        let waitAction = SKAction.wait(forDuration: 0.02) // 更新間隔
        let movementSequence = SKAction.sequence([updateAction, waitAction])
        bird.run(SKAction.repeatForever(movementSequence))
    }
    
    // ノードごとの方向変更タイミングをランダムにスケジュール
    func scheduleRandomDirectionChange(for bird: SKSpriteNode) {
        let randomInterval = TimeInterval.random(in: 1.0...3.0) // 1〜3秒の間隔で変更
        Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { [weak self, weak bird] _ in
            guard let bird = bird else { return }
            self?.movementDirections[bird] = self?.randomDirectionVector()
            self?.scheduleRandomDirectionChange(for: bird) // 再スケジュール
        }
    }
    
    // ノードの位置を更新
    func updatePosition(for bird: SKSpriteNode) {
        guard let direction = movementDirections[bird] else { return }
        
        // 新しい位置を計算
        let newPosition = CGPoint(
            x: bird.position.x + direction.dx * 0.02,
            y: bird.position.y + direction.dy * 0.02
        )
        
        // 画面の範囲を計算（中央原点を考慮）
        let screenBounds = CGRect(
            x: -size.width / 2,
            y: -size.height / 2,
            width: size.width,
            height: size.height
        )
        
        // 画面外に出そうなら反射させる
        var newDirection = direction
        if !screenBounds.contains(newPosition) {
            if newPosition.x <= screenBounds.minX || newPosition.x >= screenBounds.maxX {
                newDirection.dx = -newDirection.dx
            }
            if newPosition.y <= screenBounds.minY || newPosition.y >= screenBounds.maxY {
                newDirection.dy = -newDirection.dy
            }
            movementDirections[bird] = newDirection // 反射後の方向を保存
        } else {
            bird.position = newPosition
        }
        
        // 進行方向に応じて向きを調整
        if newDirection.dx > 0 {
            bird.xScale = -abs(bird.xScale) // 右向きに反転
        } else if newDirection.dx < 0 {
            bird.xScale = abs(bird.xScale) // 左向きに戻す
        }
    }
    
    // タッチイベントの処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // タッチされたノードを特定
        if let tappedNode = nodes(at: location).first(where: { $0 is SKSpriteNode }) as? SKSpriteNode {
//            handleTap(on: tappedNode)
            print(tappedNode)
        }
    }
    
    // タップ時の処理
    func handleTap(on node: SKSpriteNode) {
        if birds.contains(node) {
            // 例: 鳥を一時停止させて色を変更
            node.removeAllActions()
            node.color = .red
            node.colorBlendFactor = 1.0
            
            // 1秒後に再び動き始める
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self, weak node] in
                guard let node = node else { return }
                self?.startContinuousMovement(for: node)
            }
        }
    }
}
