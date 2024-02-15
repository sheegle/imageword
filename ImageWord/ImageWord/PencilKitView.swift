//
//  PencilView.swift
//  ImageWord
//
//  Created by 渡邊 翔矢 on 2024/01/12.
//

import SwiftUI
import PencilKit

struct PenKitView: UIViewRepresentable {
    typealias UIViewType = PKCanvasView
    let toolPicker = PKToolPicker()
    
    @Binding var drawnImage: UIImage? // 描画されたイラストを保存するプロパティ
    
    init(drawnImage: Binding<UIImage?>) {
        self._drawnImage = drawnImage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    @State private var canvasView: PKCanvasView?
    
    func makeUIView(context: Context) -> PKCanvasView {
        let pkcView = PKCanvasView()
        pkcView.drawingPolicy = .anyInput
        pkcView.delegate = context.coordinator
        toolPicker.addObserver(pkcView)
        toolPicker.setVisible(true, forFirstResponder: pkcView)
        pkcView.becomeFirstResponder()
        
        self.canvasView = pkcView
        
        // ナビゲーションバーに保存ボタンを追加
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: context.coordinator, action: #selector(context.coordinator.saveDrawing))
        pkcView.window?.rootViewController?.navigationItem.rightBarButtonItem = saveButton
        
        return pkcView
    }
    
    
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // 更新がある場合の処理
    }
    
    func saveDrawing() {
        // canvasViewがnilの場合は処理をスキップ
        guard let canvasView = canvasView else {
            return
        }
        
        DispatchQueue.main.async {
            let image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawnImage = image // 描画されたイラストを保存
        }
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PenKitView
        
        init(_ parent: PenKitView) {
            self.parent = parent
        }
        
        @objc func saveDrawing() {
            parent.saveDrawing()
        }
    }
}

struct PenKitView_Previews: PreviewProvider {
    static var previews: some View {
        PenKitView(drawnImage: .constant(nil))
    }
}
