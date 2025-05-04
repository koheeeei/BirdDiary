import SpriteKit
import SwiftUI
import AVFoundation


class Bird2Scene: SKScene {
//    var backgroundNode: SKSpriteNode?
//    var bird: BirdNode?
    
    var branch1Node: SKSpriteNode?
    var branch2Node: SKSpriteNode?
    
    // 鳥の配列を管理
    var birds: [BirdNode] = []
    
    var branches: [Branch] = []
    
    // 時計用ノード
    var clockLabel: SKLabelNode!
    var clockUpdateTimer: Timer?
    
    @AppStorage("lastPauseTime") var lastPauseTime: Double?
    var totalPausedTime: TimeInterval = 0
    var timerStartTime: Date?
    var backgroundElapsedTime: TimeInterval?
    var backgroundElapsedTimeLabel: SKLabelNode!
    
    var audioPlayer: AVAudioPlayer?
    
    var timer: Timer?
    
    
    // 鳥が初期位置にいるかどうか
//    var isAtInitialPosition = true
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        
        let sound = SKAction.playSoundFileNamed("silence.mp3", waitForCompletion: false)
        run(sound)
        
        // 背景
//        let background = SKSpriteNode(imageNamed: "background2")
//        background.size = size
//        background.zPosition = -1
//        addChild(background)
//        backgroundNode = background
        
        self.backgroundColor = SKColor(red: 0.142391, green: 0.547008, blue: 1, alpha: 1)
                
        // 枝の作成
        let branch1 = Branch(id: 1,
                             position: CGPoint(x: 50, y: -400),
                             size: size,
                             availablePositions: [CGPoint(x: 60, y: 360), CGPoint(x: 150, y: 370), CGPoint(x: 240, y: 373)])
        
        let branch2 = Branch(id: 2,
                             position: CGPoint(x: 80, y: 350),
                             size: CGSize(width: size.width * 0.9, height: size.height * 0.4),
                             availablePositions: [CGPoint(x: -240, y: 30), CGPoint(x: -90, y: 30), CGPoint(x: 60, y: 30)])
        
        // 枝の配列に追加
        branches.append(branch1)
        branches.append(branch2)

        // 枝のビジュアルノードを作成
        for branch in branches {
            let branchNode = SKSpriteNode(imageNamed: branch.imageName)
            branchNode.size = branch.size
            branchNode.position = branch.position
            branchNode.zPosition = -1
            addChild(branchNode)
        }
        
//        // 鳥の追加（例: branch1の1番目の位置にとまる）
//        addBird(at: branch1.getPosition(at: 0)!, on: branch1)
//        addBird(at: branch2.getPosition(at: 2)!, on: branch2)
//
        
        // 鳥を複数追加
        addBird(at: branch1.availablePositions[0], branchId: 1)
        addBird(at: branch1.availablePositions[1], branchId: 2)
        addBird(at: branch1.availablePositions[2], branchId: 3)
        
        
        // 時計を追加
        clockLabel = SKLabelNode(fontNamed: "Helvetica")
        clockLabel.fontSize = 24
        clockLabel.fontColor = .white
        clockLabel.position = CGPoint(x: 100, y: 100) // 画面上部中央
        clockLabel.zPosition = 10
        addChild(clockLabel)
        
        // バックグラウンド経過時間を追加
        backgroundElapsedTimeLabel = SKLabelNode(fontNamed: "Helvetica")
        backgroundElapsedTimeLabel.fontSize = 24
        backgroundElapsedTimeLabel.fontColor = .white
        backgroundElapsedTimeLabel.position = CGPoint(x: 100, y: 70) // 画面上部中央
        backgroundElapsedTimeLabel.zPosition = 10
        addChild(backgroundElapsedTimeLabel)
        
        printTotalPausedTime()
        
        // 時計の更新を開始
        startClock()
        
        // BGMを再生
        playBackgroundMusic()
        
        
//        self.timer = Timer.scheduledTimer(timeInterval: randomTimeInterval, target: self, selector: #selector(addBird2), userInfo: nil, repeats: true)
        performRandomTask()
        
        performRandomTask_c()
    }
    
    // 鳥を追加する共通メソッド
    func addBird(at position: CGPoint, branchId: Int) {
//        let birdModel = Bird()
        let bird = BirdNode(bird: Bird())
        bird.position = position
        bird.size = CGSize(width: 100, height: 100)
        bird.zPosition = 1
        addChild(bird)
        bird.branchId = branchId
        
        // タッチ処理でこの鳥を判定するため、配列に追加
        birds.append(bird)
    }

    
    func playBackgroundMusic() {
        setupAudioSession()
        if let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 0.3 // 音量30%
                audioPlayer?.numberOfLoops = -1 // ループ再生
                audioPlayer?.play()
            } catch {
                print("BGMの再生に失敗しました: \(error)")
            }
        }
    }
    
    
    func setupAudioSession() {
        do {
            // AVAudioSession.Category.ambientを設定して他の音楽（Apple Music など）を停止せずに、アプリの音声をバックグラウンドで流す
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSessionの設定に失敗しました: \(error)")
        }
    }
    
    @objc func appDidEnterBackground() {
        print("App entered background")
        lastPauseTime = Date().timeIntervalSince1970 // Double 型として保存
//        print("lastPauseTime set to:", lastPauseTime ?? "nil")
        
        audioPlayer?.pause()
        
        // タイマーを一時停止
        clockUpdateTimer?.invalidate()
        clockUpdateTimer = nil
        // シーンの動作を一時停止
        self.isPaused = true
    }

    @objc func appWillEnterForeground() {
        print("App entered foreground")
        printTotalPausedTime()
        
        audioPlayer?.play()
        
        // タイマーを再開
        startClock()
        // シーンの動作を再開
        self.isPaused = false
    }
    
    
    func printTotalPausedTime() {
        if let lastPauseTime = lastPauseTime {
            let lastPauseDate = Date(timeIntervalSince1970: lastPauseTime)
            backgroundElapsedTime = Date().timeIntervalSince(lastPauseDate)
            print("total paused time:", backgroundElapsedTime ?? "エラー")
            updateBackgroundElapsedTime()
        }
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
//        lastPauseTime = Date()
        
        lastPauseTime = Date().timeIntervalSince1970 // Double 型として保存
        
        // BGM を停止
        audioPlayer?.stop()
        audioPlayer = nil
        
        // タイマーを停止
        clockUpdateTimer?.invalidate()
        clockUpdateTimer = nil
        
        // シーン内の動作を一時停止
        self.isPaused = true
        
        // 通知の登録を解除
        NotificationCenter.default.removeObserver(self)
        
        print("Scene is about to be removed from the view.")
    }

    
    // 時計の更新を開始
    func startClock() {
        updateClock() // 初期表示の更新
        clockUpdateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    // 時計の更新
    @objc func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let currentTime = formatter.string(from: Date())
        clockLabel.text = "Current Time: \(currentTime)"
    }
    
    
    @objc func updateBackgroundElapsedTime() {
        if let backgroundElapsedTime = backgroundElapsedTime {
            backgroundElapsedTimeLabel.text = "Background Elapsed Time: \(Int(backgroundElapsedTime))s"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // タップされた鳥を特定
        for bird in birds {
            if bird.contains(location) {
                handleBirdTap(bird)
                break
            }
        }
        
        // 鳥がタップされた際の処理
        func handleBirdTap(_ tappedBird: BirdNode) {
            let sound = SKAction.playSoundFileNamed("hidorigamo.mp3", waitForCompletion: false)
            run(sound)
            
            // すでにフラップアクションが走ってないかチェック
            if tappedBird.action(forKey: "flapping") == nil {
                let flapSequence = SKAction.run {
                    tappedBird.toggleFlapImage()
                }
                let flapDelay = SKAction.wait(forDuration: 0.05)
                let flapLoop = SKAction.repeatForever(.sequence([flapSequence, flapDelay]))
                tappedBird.run(flapLoop, withKey: "flapping")
            }
            
            // パーティクルエミッタノードを作成
            let particle = SKEmitterNode(fileNamed: "Particle.sks") // "Particle.sks" は事前に作成したパーティクルファイル
            particle?.position = CGPoint(x: tappedBird.position.x, y: tappedBird.position.y - 30)
            particle?.zPosition = 1
            //            particle?.setScale(0.5)  必要に応じてスケールを調整
            
            
            
            // 移動先とスケールを決定
            let targetScale2: CGFloat
            
            if tappedBird.isAtInitialPosition {
                // 初期位置 → 左側へ
                targetScale2 = 1.0    // 左向き
                //                targetScale2 = 3.0
                particle?.setScale(0.3) // 必要に応じてスケールを調整
            } else {
                // 左側 → 初期位置へ戻る
                targetScale2 = -3.0   // 右向きに反転
                //                targetScale2 = 1.0
            }
            
            // 移動+スケール
            let flip = SKAction.scaleX(to: targetScale2, duration: 0)
            
            // 移動先とスケールを決定
            let targetPosition: CGPoint
            let targetScaleX: CGFloat
            let targetScaleY: CGFloat
            
            if let branchId = tappedBird.branchId {
                
                if tappedBird.isAtInitialPosition {
                    // 初期位置 → 左側へ
                    targetPosition = branches[1].availablePositions[branchId-1]
                    targetScaleX = 3.0
                    targetScaleY = 3.0
                } else {
                    // 左側 → 初期位置へ戻る
                    targetPosition = branches[0].availablePositions[branchId-1]
                    targetScaleX = -1.0
                    targetScaleY = 1.0
                }
                
                // 移動+スケール
                let move = SKAction.move(to: targetPosition, duration: 0.6)
                let scaleX = SKAction.scaleX(to: targetScaleX, duration: 0.6)
                let scaleY = SKAction.scaleY(to: targetScaleY, duration: 0.6)
                let group = SKAction.group([move, scaleX, scaleY])
                
                // パーティクルをシーンに追加
                if let particle = particle {
                    self.addChild(particle)
                    
                    // 一定時間後にパーティクルを削除
                    let removeParticle = SKAction.sequence([
                        SKAction.wait(forDuration: 0.4), // 表示時間
                        SKAction.removeFromParent()
                    ])
                    particle.run(removeParticle)
                }
                
                // シーケンスで順序指定
                let sequence = SKAction.sequence([
                    flip,      // まず0秒で反転を完了
                    group             // そのあと同時に移動 & サイズ変更
                ])
                
                // アクション実行
                tappedBird.run(sequence) {
                    // フラップ停止
                    tappedBird.removeAction(forKey: "flapping")
                    // bird3_0 に戻す
                    tappedBird.setTexture(named: "bird3_0")
                    // 次回タップに備えてフラグ反転
                    tappedBird.isAtInitialPosition.toggle()
                }
            }
            
        }
        
        
        
    }
    
    
    @objc func runBackgroundBird(_ backgroundBird: BackgroundBirdNode) {
        // 羽ばたきアクション
        let flapSequence = SKAction.run {
            backgroundBird.toggleFlapImage()
        }
        let flapDelay = SKAction.wait(forDuration: 0.05)
        let flapLoop = SKAction.repeatForever(.sequence([flapSequence, flapDelay]))

        // 移動アクション
        let targetPosition = CGPoint(x: backgroundBird.position.x - 1000, y: backgroundBird.position.y)
        let move = SKAction.move(to: targetPosition, duration: 5.0)

        // ノード削除アクション
        let removeBird = SKAction.run {
            backgroundBird.removeFromParent()
        }

        // 羽ばたきアクションと移動・削除アクションを並列で実行するアクションを作成
        let moveAndRemove = SKAction.sequence([move, removeBird])
        let combinedAction = SKAction.group([flapLoop, moveAndRemove])

        // backgroundBird にアクションを実行
        backgroundBird.run(combinedAction, withKey: "flappingAndMoving")

    }
    
    // 鳥を追加する共通メソッド
    @objc func addBackgroundBird() {
        let position = CGPoint(x: 500, y: 400)
        let backgroundBird = BackgroundBirdNode()
        backgroundBird.position = position
        backgroundBird.size = CGSize(width: 50, height: 50)
        backgroundBird.zPosition = -10
        addChild(backgroundBird)
        
        runBackgroundBird(backgroundBird)
        
        // タッチ処理でこの鳥を判定するため、配列に追加
//        birds.append(backgroundBird)
    }
    
    func performRandomTask() {
        // 乱数生成（1〜5秒の間でランダムな時間を設定）
        let randomDelay = Double.random(in: 0.1...5.0)

        // ランダム時間後に処理を実行
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            // 実行したい処理
            self.addBackgroundBird()
            
            // 再帰的に次の処理をスケジュール
            self.performRandomTask()
        }
    }
    
    
    
    
    
    @objc func runCloud(_ cloud: CloudNode) {
        // 移動アクション
        let targetPosition = CGPoint(x: cloud.position.x - 1000, y: cloud.position.y)
        let move = SKAction.move(to: targetPosition, duration: 250.0)

        // ノード削除アクション
        let removeBird = SKAction.run {
            cloud.removeFromParent()
        }

        // 羽ばたきアクションと移動・削除アクションを並列で実行するアクションを作成
        let moveAndRemove = SKAction.sequence([move, removeBird])
//        let combinedAction = SKAction.group([flapLoop, moveAndRemove])
        
        let combinedAction = SKAction.group([moveAndRemove])

        // cloud にアクションを実行
        cloud.run(combinedAction, withKey: "flappingAndMoving")

    }
    
    @objc func addCloud() {
        let position = CGPoint(x: 500-350, y: 400)
        let cloud = CloudNode()
        cloud.position = position
        cloud.size = CGSize(width: 900, height: 900)
        cloud.zPosition = -11
        addChild(cloud)
        
        runCloud(cloud)
        
        // タッチ処理でこの鳥を判定するため、配列に追加
//        birds.append(bird2)
    }
    
    func performRandomTask_c() {
        // 実行したい処理
        self.addCloud()
    }
}
