//
//  InvestmentViewModel.swift
//  MinigamesMZ
//
//  Created by mnats on 23.11.2023.
//

import SwiftUI

final class InvestmentViewModel: ObservableObject {
    @Published var chartData: [Double] =  [
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
        Double.random(in: 45...55),
    ]
    @Published var chartColor: Color = .blue
    @Published var minY: Double = 0
    @Published var maxY: Double = 100
    @Published var entryPoint: Double = 0
    @Published var buttonDisabled = false
    @Published var isFinishPresented = false
    @Published var gameResult: GameResult = .draw
    var steps = 50
    
    init() {
        restart()
    }
    
    func showFinishScreen() {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                isFinishPresented = true
            }
        }
    }
    
    private func moveUp(_ offset: Double = 50) {
        let endPoint = maxY + offset
        chartData.append(endPoint)
        chartData.remove(at: 0)
        minY = chartData.min()! - 20
        maxY = chartData.max()! + 20
    }
    
    private func moveDown(_ offset: Double = 50) {
        let endPoint = minY - offset
        chartData.append(endPoint)
        chartData.remove(at: 0)
        minY = chartData.min()! - 20
        maxY = chartData.max()! + 20
    }
    
    func win() {
        moveUp()
        chartColor = .green
        gameResult = .win
        showFinishScreen()
    }
    
    func lose() {
        moveDown()
        chartColor = .red
        gameResult = .lose
        showFinishScreen()
    }
    
    func restart() {
        buttonDisabled = false
        isFinishPresented = false
        chartColor = .blue
    }
    
    func play() async {
        let stages: [Int] = Array(Array(2..<steps - 2).shuffled().prefix(7))
        print(stages.count)
        buttonDisabled = true
        entryPoint = chartData.last!
        var currentEntryPoint = entryPoint
        withAnimation {
            chartColor = .blue
        }
        for i in 1..<steps {
                if stages.contains(i) {
                    currentEntryPoint += Double.random(in: -50...50)
                }
            chartData.append(currentEntryPoint + Double.random(in: -3...3))
            chartData.remove(at: 0)
            minY = chartData.min()! - 20
            maxY = chartData.max()! + 20
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        withAnimation {
            Bool.random() ? win() : lose()
        }
    }
}
