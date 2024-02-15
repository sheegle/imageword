//
//  AddView.swift
//  ImageWord
//
//  Created by 渡邊 翔矢 on 2024/01/04.
//

import SwiftUI
import PencilKit



struct AddFlashcardView: View {
    @Binding var flashcards: [Flashcard]
    @Binding var newWord: String
    @Binding var newImageName: String
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var isAddFlashcardActive: Bool = false
    @State private var drawnImage: UIImage? // 描画されたイラストを保存するプロパティ
    @State private var isDrawingActive: Bool = false // プッシュ遷移を管理するフラグ
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Flashcard")) {
                    TextField("New Word", text: $newWord)
                        // ここにPencilKitの描画機能を追加
                        Button("Draw Here") {
                            isDrawingActive = true
                    }
                }
                
                
                Section {
                    Button("Add Flashcard") {
                            // 描画機能を選んだ場合、描かれたイラストがあるかどうかを確認
                            if let drawnImage = drawnImage {
                                saveImage(drawnImage, imageName: UUID().uuidString)
                            }
                            
                            newWord = ""
                            newImageName = ""
                            drawnImage = nil
                            presentationMode.wrappedValue.dismiss()
                        
                    }
                    .disabled(newWord.isEmpty || drawnImage == nil)
                }
            }
            
            .navigationTitle("Add Flashcard")
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
            )
            
            NavigationLink(
                destination:
                        // 遷移先の View（"addflashcardのボタンが押せるview" と仮定）
                        AddFlashcardView(flashcards: $flashcards, newWord: $newWord, newImageName: $newImageName)
,
                isActive: $isAddFlashcardActive
            ) {
                EmptyView()
            }
            
            NavigationStack {
                NavigationLink(
                    destination:
                            PenKitView(drawnImage: $drawnImage)
                                .navigationBarItems(
                                    trailing: Button("Save") {
                                            self.isDrawingActive = false
                                        guard let image = self.drawnImage else {
                                            print("Error: drawnImage is nil")
                                            return
                                        }
                                        self.saveImage(image, imageName: "yourImageName")
                                    }
                                ),
                    isActive: $isDrawingActive
                ) {
                    EmptyView()
                }

            .navigationTitle("Add Flashcard")
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
            )
            }
    }
}
    
    func saveImage(_ image: UIImage, imageName: String) {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let imageUrl = documentDirectory.appendingPathComponent(imageName)
        try? data.write(to: imageUrl)
        flashcards.append(Flashcard(question: newWord, answerImageName: imageUrl.path))
    }
}
