import SpriteKit
import AVFoundation

class BackgroundBirdNode: SKSpriteNode {
    // フラップ用の画像
//    private let flapImageNames = ["bird_0", "bird2_0"]
    private let flapImageNames = ["1-1_transparent", "1-2_transparent", "1-3_transparent", "1-4_transparent"]
    private var currentImageIndex: Int = 0
    

    init() {
        let texture = SKTexture(imageNamed: "1-1_transparent")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.isUserInteractionEnabled = false
        // 必要ならアンカーポイントを変更
        // self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // フラップ時に bird_0 と bird2_0 を交互に表示
    func toggleFlapImage() {
        currentImageIndex = (currentImageIndex + 1) % flapImageNames.count
        self.texture = SKTexture(imageNamed: flapImageNames[currentImageIndex])
    }
}
