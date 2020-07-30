//
//  ContentView.swift
//  Memorize
//
//  Created by Matthew Wu on 6/17/20.
//  Copyright © 2020 Matthew Wu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
        
    var body: some View {
        VStack {
            Text("\(themeText(themeIndex: EmojiMemoryGame.themeChoice))")
                .padding(.top, 30)
                .font(Font.system(size: 30))
            
            Text("Points: \(viewModel.gamePoints)")
                .padding(.top, 10)
                .font(.headline)
            
            Grid (viewModel.cards) { card in
                cardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        self.viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
                }
            .foregroundColor(themeChosen(themeIndex: EmojiMemoryGame.themeChoice))
                .padding()
            
            buttonView()
            
        }
    }
    
    private func themeChosen(themeIndex index: Int) -> Color {
        let colorArray = [Color.orange, Color.blue, Color.green, Color.purple, Color.gray, Color.red]
        return colorArray[index]
    }
    
    private func themeText(themeIndex index: Int) -> String {
        let themeArray = ["Halloween", "Beach", "Sports", "Food", "Numbers", "Countries"]
        return themeArray[index]
    }
    
    private func buttonView() -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                self.viewModel.resetGame()
            }
        }, label: { Text("New Game")
            .padding(8)
            .foregroundColor(Color.white)
            .background(Color.red)
            .font(.headline)
        })
    }
}

struct cardView : View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader(content : { geometry in
            self.body(for: geometry.size)
        })
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonus {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockWise: true)
                        .onAppear() {
                            self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockWise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(AnyTransition.scale)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            //.modifier(Cardify(isFaceUp: card.isFaceUp))
                .cardify(isFaceUp: card.isFaceUp)
            // viewModel.cards.count == 10 ? Font.title :
                .transition(AnyTransition.scale)
                
        }
    }

    private let fontScaleFactor : CGFloat = 0.7
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
