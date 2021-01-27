//
//  EmojiMemoryGameView.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    // MARK: - States and Functions
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @State private var showingThemeEdit = false
    
    private func generateActionSheet(themes: [MemoryGame<String>.Theme]) -> ActionSheet {
        let buttons = themes.enumerated().map { i, theme in
            Alert.Button.default(Text(theme.name), action: {
                withAnimation(.easeInOut(duration: 0.7)) {
                    viewModel.changeTheme(theme)
                }
            })
        }
        return ActionSheet(title: Text("Change Theme"), buttons: buttons + [Alert.Button.cancel()])
    }
    
    // MARK: - Main Body
    
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
                        withAnimation(.linear(duration: 0.7)) {
                            viewModel.choose(card)
                        }
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
                    Image(systemName: "pencil.circle.fill")
                        .scaleEffect(1.5)
                }
                .padding(.trailing)
                
                Button {
                    withAnimation(.easeInOut) {
                        viewModel.resetGame()
                    }
                } label: {
                    Image(systemName: "restart.circle")
                        .scaleEffect(1.5)
                }
            }

        }
        .padding()
        .actionSheet(isPresented: $showingThemeEdit) {
            generateActionSheet(themes: EmojiMemoryGame.themes)
        }
    }
}

// MARK: - Card View

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees((-animatedBonusRemaining*360)-90), clockwise: true)
                                .onAppear {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees((-card.bonusRemaining*360)-90), clockwise: true)
                        }
                    }
                    .padding(5)
                    .opacity(0.4)
                    
                    Text(card.content)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(Animation.linear(duration: 0.7).repeatCount(2, autoreverses: false))
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
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


