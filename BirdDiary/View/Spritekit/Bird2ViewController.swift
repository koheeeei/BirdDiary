//
//  GameViewController.swift
//  fdfa
//
//  Created by KI on 2024/11/23.
//

import SwiftUI
import UIKit
import SpriteKit

struct Bird2View: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Bird2ViewController {
        return Bird2ViewController()
    }

    func updateUIViewController(_ uiViewController: Bird2ViewController, context: Context) {
        // 必要に応じて更新ロジックを実装
    }
}

// 通知センター・コントロールセンターを開いている間もシーンを止めない
class Bird2ViewController: UIViewController {
    private var skView: SKView? // SKViewを保持
    private var isScenePaused = false // シーンの状態を管理

    override func loadView() {
        // SKViewを初期化して、viewに設定します
        self.view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // SKViewを取得する
        guard let skView = self.view as? SKView else { return }
        self.skView = skView
        self.skView?.showsFPS = true
        self.skView?.showsNodeCount = true

        // SKSファイルを指定してSKSceneインスタンスを生成する
        if let scene = Bird2Scene(fileNamed: "Bird2Scene") {
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }

        // アプリ状態に応じた動作制御のための通知監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // シーン内のタイマーを停止
        if let skView = self.skView, let scene = skView.scene as? Bird2Scene {
            scene.clockUpdateTimer?.invalidate()
            scene.clockUpdateTimer = nil
        }

        // SKViewからシーンを削除
        skView?.presentScene(nil)
    }

    @objc private func handleWillResignActive() {
        // 通知センターやコントロールセンターの場合は動作を維持
        if UIApplication.shared.applicationState == .active {
            skView?.isPaused = false
        } else {
            skView?.isPaused = true
            isScenePaused = true
        }
    }

    @objc private func handleDidBecomeActive() {
        if isScenePaused {
            skView?.isPaused = false
            isScenePaused = false
        }
    }

    @objc private func handleDidEnterBackground() {
        skView?.isPaused = true
        isScenePaused = true
    }

    @objc private func handleWillEnterForeground() {
        if isScenePaused {
            skView?.isPaused = false
            isScenePaused = false
        }
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
