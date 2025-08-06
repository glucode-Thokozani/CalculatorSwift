//
//  ContentView.swift
//  Calculate
//
//  Created by Thokozani Mncube on 2025/08/01.
//

import SwiftUI
import Foundation
import ConfettiSwiftUI

struct ContentView: View {
    @StateObject private var calculator = Calculator()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    NavigationLink(destination: ScientificCalculator()) {
                        Image("Scientific")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.all ,10)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            VisualMathScene(
                                operatorSymbol: calculator.lastOperator,
                                input: calculator.lastVal2.map { String($0) } ?? "",
                                value1: calculator.lastVal1,
                                explanation: $calculator.explanationText
                            )
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.5)
                            
                            VStack(alignment: .trailing, spacing: 10) {
                                
                                Text(buildExpression(value1: calculator.value1, operator: calculator.operators, input: calculator.input))
                                    .font(.system(size: 25, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                Text(calculator.result)
                                    .font(.system(size: 35, weight: .bold))
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .confettiCannon(trigger: $calculator.showConfetti, colors: [.red, .blue, .green], repetitions: 3, repetitionInterval: 0.2)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4)
                        }
                        
                        calculatorButtons
                            .frame(height: geometry.size.height * 0.45)
                            .padding()
                    }
                }
            }
        }
    
    
    var calculatorButtons: some View {
        let buttons: [[String]] = [
            ["C", "%", "÷"],
            ["7", "8", "9", "x"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "⌫", "="]
        ]
        
        return VStack(spacing: 10) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { symbol in
                        Button(action: { calculator.handleButtonPress(symbol) }) {
                            Text(symbol)
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, minHeight: 55)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}

        struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
