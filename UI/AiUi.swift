//
//  AiUi.swift
//  Calculate
//
//  Created by Thokozani Mncube on 2025/08/01.
//
import SwiftUI
import Foundation
import ConfettiSwiftUI

struct VisualMathScene: View {
    var operatorSymbol: String?
    var input: String
    var value1: Double?
    @Binding var explanation: String

    var body: some View {
        VStack {
            Text("Cartoon Math Explanation")
                .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        //initially had characters for each operator
                    }
                    .frame(maxWidth: 800, alignment: .leading)
                }

                ScrollView(.vertical, showsIndicators: true) {
                    Text(explanation)
                        .font(.footnote)
                        .padding()
                        .foregroundColor(.black)
                }
                .frame(maxHeight: 300)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
                .padding(.top, 4)
        }
        .padding(8)
        .background(backgroundColor(for: operatorSymbol ?? ""))
        .cornerRadius(10)
    }


    /*func getCharacterName(for op: String) -> String? {
        switch op {
        case "+": return "Addy"
        case "-": return "Minny"
        case "x": return "Max"
        case "÷": return "Divvy"
        case "%": return "Percy"
        case "Sin": return "Siney"
        case "Cos": return "Cossy"
        case "Tan": return "Tanny"
        case "!": return "Facto"
        case "log": return "Loggy"
        case "√": return "Roota"
        case "π": return "Pieface"
        case "e": return "Eulerella"
        default: return nil
        }
    }*/

    
    func backgroundColor (for op: String) -> Color{
        switch op{
        case "+":
            return Color.pink.opacity(1)
        case "-":
            return Color.blue.opacity(1)
        case "x":
            return Color.orange.opacity(1)
        case "÷":
            return Color.teal.opacity(1)
        case "%":
            return Color.purple.opacity(1)
        case "Sin":
            return Color.red.opacity(1)
        case "Cos":
            return Color.green.opacity(1)
        case "Tan":
            return Color.yellow.opacity(1)
        case "!":
            return Color.indigo.opacity(1)
        case "log":
            return Color.mint.opacity(1)
        case "√":
            return Color.cyan.opacity(1)
        case "π":
            return Color.black.opacity(1)
        case "e":
            return Color.brown.opacity(1)
        default: return Color.gray.opacity(1)
        }
    }
}

