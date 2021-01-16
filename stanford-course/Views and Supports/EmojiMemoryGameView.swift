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
    
    private func generateActionSheet(themes: [MemoryGame<String>.Theme]) -> ActionSheet {
        let buttons = themes.enumerated().map { i, theme in
            Alert.Button.default(Text(theme.name), action: {
                viewModel.changeTheme(theme)
            })
        }
        return ActionSheet(title: Text("Change Theme"), buttons: buttons + [Alert.Button.cancel()])
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Memory Game - \(viewModel.theme.name) Theme")
                    .font(.title3)
                    .bold()
                Spacer()
            }
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
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                        .padding(5)
                        .opacity(0.4)
                    Text(card.content)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
    }
    
    //MARK: - Drawing Constants
    private let fontScaleFactor: CGFloat = 0.7
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards[0])
        
        return EmojiMemoryGameView(viewModel: game)
    }
}


