import SpriteKit
import AVFoundation

class CloudNode: SKSpriteNode {
    // フラップ用の画像
//    private let flapImageNames = ["bird_0", "bird2_0"]
    private let flapImageNames = ["cloud"]
    private var currentImageIndex: Int = 0
    

    init() {
        let texture = SKTexture(imageNamed: "cloud")
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
