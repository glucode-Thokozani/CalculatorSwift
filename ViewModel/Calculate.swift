//
//  Calculate.swift
//  Calculate
//
//  Created by Thokozani Mncube on 2025/08/01.
//
import SwiftUI
import Foundation
import ConfettiSwiftUI

enum Calculate {
    case Add, Subtract, Multiply, Divide, Percent, Sin, Cos, Tan, Factorial, Exponent, Pi, Euler, Logarithm, SquareRoot
}

func degreesToRadians(degree: Double) ->Double{
    return degree * .pi / 180
}

func evaluate(`operator`: Calculate, num1: Double, num2: Double) -> Double {
    switch `operator` {
    case .Add:
        return num1 + num2
        
    case .Subtract:
        return num1 - num2
        
    case .Multiply:
        return num1 * num2
        
    case .Divide:
        return num2 != 0 ? num1 / num2 : 0.0
        
    case .Percent:
        return (num1 / num2) * 100
        
    case .Sin:
        return sin(degreesToRadians(degree: num1))
        
    case .Cos:
        return cos(degreesToRadians(degree: num1))
        
    case .Tan:
        return tan(degreesToRadians(degree: num1))
        
    case .Factorial:
        guard num1 >= 0, num1 == floor(num1) else {
            return 0.0
        }; var result = 1.0
        for i in 1...Int(num1){
            result *= Double(i)
        }
        return result
        
    case .Exponent:
        return pow(num1, num2)
        
    case .Pi:
        return Double.pi
        
    case .Euler:
        return M_E
    
    case .Logarithm:
        return num1 > 0 ? log10(num1): 0.0
        
    case .SquareRoot:
        return num1 >= 0 ? sqrt(num1) : 0.0
    }
}

func calculate(value1: Double?, value2: Double?, sign: String) -> String {
    guard let val1 = value1, let val2 = value2 else { return "Error" }

    let operation: Calculate
    switch sign {
    case "+": operation = .Add
    case "-": operation = .Subtract
    case "x": operation = .Multiply
    case "÷": operation = .Divide
    case "%": operation = .Percent
    case "Sin" :operation = .Sin
    case "Cos" :operation = .Cos
    case "Tan" :operation = .Tan
    case "!" :operation = .Factorial
    case "xⁿ" :operation = .Exponent
    case "π" :operation = .Pi
    case "e" :operation = .Euler
    case "log" :operation = .Logarithm
    case "√" :operation = .SquareRoot
    default: return "Error"
    }

    let result = evaluate(operator: operation, num1: val1, num2: val2)
    
    let rounded = round(result * 100) / 100
    return String (format: "%.2f", rounded)
}

func buildExpression(value1: Double?, operator: String?, input: String) -> String{
    var expression = ""
    if let v1 = value1 {
        expression += v1.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(v1)) : String(format : "%.2f", v1)
    }
    if let op = `operator` { expression += "\(op)" }
    
    expression += input
    return expression
}

class Calculator: ObservableObject {
    @Published var input: String = ""
    @Published var result: String = ""
    @Published var value1: Double? = nil
    @Published var value2: Double? = nil
    @Published var operators: String? = nil
    @Published var showConfetti = false
    @Published var explanationText: String = "Let me explain...😎"
    @Published var lastVal1: Double? = nil
    @Published var lastVal2: Double? = nil
    @Published var lastOperator: String? = nil

    private let groqApi = GroqApi()

    func handleButtonPress(_ symbol: String) {
        switch symbol {
        case "=":
            guard let op = operators, let val1 = value1, !input.isEmpty,
                  let val2 = Double(input) else {
                result = "Error"
                return
            }

            lastOperator = op
            lastVal1 = val1
            lastVal2 = val2

            let calculated = calculate(value1: val1, value2: val2, sign: op)
            result = calculated

            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showConfetti = false
            }

            requestAIExplanation(for: op, num1: val1, num2: val2)

        case "C":
            input = ""
            result = ""
            value1 = nil
            value2 = nil
            operators = nil
            explanationText = "Waiting for maths"

            requestAIExplanation(for: operators ?? "", num1: value1 ?? 0.0, num2: value2 ?? 0.0)

        case "⌫":
            if !input.isEmpty {
                input.removeLast()
            }

        case "+", "-", "x", "÷", "%":
            if !input.isEmpty {
                value1 = Double(input)
                operators = symbol
                input = ""
            } else if !result.isEmpty {
                value1 = Double(result)
                operators = symbol
                input = ""
            }

        case "Sin", "Cos", "Tan", "log", "√", "!":
            let numStr = input.isEmpty ? result : input
            if let num = Double(numStr) {
                lastOperator = symbol
                lastVal1 = num
                lastVal2 = 0

                let calculated = calculate(value1: num, value2: 0, sign: symbol)
                result = calculated
                //input = ""

                requestAIExplanation(for: symbol, num1: num)
            } else {
                explanationText = "Please enter a number first!"
            }

        case "π":
            let num = Double.pi
            result = String(num)
            lastOperator = symbol
            lastVal1 = num
            lastVal2 = 0
            //input = ""

            requestAIExplanation(for: symbol, num1: num)

        case "e":
            let num = M_E
            result = String(num)
            lastOperator = symbol
            lastVal1 = num
            lastVal2 = 0
            //input = ""

            requestAIExplanation(for: symbol, num1: num)

        default:
            input += symbol
        }
    }

    func requestAIExplanation(for op: String, num1: Double, num2: Double = 0) {
        let prompt = groqApi.buildExplanationPrompt(op: op, num1: num1, num2: num2)
        print("AI prompt:", prompt)

        groqApi.fetchGroqAi(prompt: prompt) { aiResponse in
            print("AI response:", aiResponse)
            DispatchQueue.main.async {
                self.explanationText = aiResponse
            }
        }
    }
}
