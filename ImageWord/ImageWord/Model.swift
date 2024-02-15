//
//  Model.swift
//  ImageWord
//
//  Created by 渡邊 翔矢 on 2024/01/04.
//

import Foundation
import UIKit

class Flashcard: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var question: String
    @Published var answerImageURL: URL? // URL型に変更
    @Published var drawnImage: UIImage? // 追加：描かれたイメージ
    @Published var isFlipped: Bool = false
    
    init(question: String, answerImageName: String) {
        self.question = question
        if let url = URL(string: answerImageName) {
            self.answerImageURL = url
        } else {
            // URLが正しく生成できなかった場合の処理
            // 例えばデフォルトの画像を表示するなど
            self.answerImageURL = nil
        }
    }
}
