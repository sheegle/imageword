//
//  FlashcardView.swift
//  ImageWord
//
//  Created by 渡邊 翔矢 on 2024/01/25.
//

import SwiftUI

struct FlashcardView: View {
    @ObservedObject var flashcard: Flashcard
    
    var body: some View {
        VStack {
            if flashcard.isFlipped {
                // 裏返り時の表示
                Image(uiImage: UIImage(contentsOfFile: flashcard.answerImageURL?.path ?? "") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                // 表の表示
                Text(flashcard.question)
                    .font(.largeTitle)
                    .padding()
            }
        }
        .rotation3DEffect(
            .degrees(flashcard.isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .onTapGesture {
            withAnimation {
                self.flashcard.isFlipped.toggle()
            }
        }
    }
}
