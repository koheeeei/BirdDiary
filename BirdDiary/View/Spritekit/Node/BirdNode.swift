import SpriteKit
import AVFoundation

class BirdNode: SKSpriteNode {
    var bird: Bird
    
    // フラップ用の画像
    private let flapImageNames = ["bird_0", "bird2_0"]
//    private let flapImageNames = ["1-1_transparent", "1-2_transparent", "1-3_transparent", "1-4_transparent"]
    private var currentImageIndex: Int = 0
    
    // 位置フラグ
    var isAtInitialPosition: Bool = true
    
    // 0：枝に留まっていない、1：枝の左の箇所、2：枝の真ん中の箇所、3：枝の右の箇所
    var branchId: Int?
    
    // 初期画像を bird3_0（枝に止まっている）に
    init(bird: Bird) {
        self.bird = bird
        let texture = SKTexture(imageNamed: "bird3_0")
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
    
    // 移動完了後などに bird3_0 に戻す用
    func setTexture(named textureName: String) {
        self.texture = SKTexture(imageNamed: textureName)
    }
}
