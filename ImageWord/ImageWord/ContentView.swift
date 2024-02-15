//
//  ContentView.swift
//  ImageWord
//
//  Created by 渡邊 翔矢 on 2024/01/02.
//

import SwiftUI

struct ContentView: View {
    @State private var  flashcards: [Flashcard] = []
    @State private var selectedFlashcard: Flashcard?
    @State private var showingSheet = false
    @State private var newWord = ""
    @State private var newImageName = ""
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(flashcards) { flashcard in
                    NavigationLink(destination: FlashcardView(flashcard: flashcard)) {
                        Text(flashcard.question)
                    }
                    .onTapGesture {
                        self.selectedFlashcard = flashcard
                    }
                }
                .onDelete(perform: deleteFlashcard)
            }
            .navigationTitle("Flashcards")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.showingSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
            )
        }
        .sheet(isPresented: $showingSheet) {
            AddFlashcardView(flashcards: self.$flashcards, newWord: self.$newWord, newImageName: self.$newImageName)
        }
    }
    
    func deleteFlashcard(at offsets: IndexSet) {
        flashcards.remove(atOffsets: offsets)
    }
}



#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
#endif

