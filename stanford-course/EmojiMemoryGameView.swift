//
//  EmojiMemoryGameView.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @State private var showingThemeEdit = false
    
    func generateActionSheet(themes: [MemoryGame<String>.Theme]) -> ActionSheet {
        let buttons = themes.enumerated().map { i, theme in
            Alert.Button.default(Text(theme.name), action: {
                viewModel.changeTheme(theme)
            })
        }
        
        return ActionSheet(title: Text("Change Theme"), buttons: buttons + [Alert.Button.cancel()])
    }
    
    var body: some View {
        VStack {
            Text("Memory Game - \(viewModel.theme.name) Theme")
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                    .padding(5)
            }
            .foregroundColor(viewModel.theme.accentColor)
            
            HStack {
                Text("Score: \(viewModel.score)")
                
                Spacer()
                
                Button {
                    showingThemeEdit.toggle()
                } label: {
                    Label("Change Theme", systemImage: "pencil.circle.fill")
                }
            }

        }
        .padding()
        .actionSheet(isPresented: $showingThemeEdit) {
            generateActionSheet(themes: EmojiMemoryGame.themes)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }
            .font(.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
        }
    }
    
    //MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
