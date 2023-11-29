////
////  CryptoViewModel.swift
////  MinigamesMZ
////
////  Created by mnats on 23.11.2023.
////
//
//import SwiftUI
//
//final class CryptoViewModel: ObservableObject {
//    @Published var chartData1: [Double] =  [
//        04, 04, 05, 08, 05, 08, 06, 03, 37, 35, 75, 38, 40, 37, 37, 36, 40, 38, 40, 38, 41, 35, 83, 81, 80, 53
//    ]
//    @Published var chartData2: [Double] =  [
//        04, 04, 05, 08, 05, 08, 06, 03, 37, 35, 75, 38, 40, 37, 37, 36, 40, 38, 40, 38, 41, 35, 83, 81, 80, 53
//    ]
//    
//    @Published var chartColor1: Color = .blue
//    @Published var chartColor2: Color = .orange
//    @Published var minY: Double = 0
//    @Published var maxY: Double = 100
//    @Published var entryPoint1: Double = 0
//    @Published var entryPoint2: Double = 0
//    @Published var buttonDisabled = false
//    @Published var isFinishPresented = false
//    @Published var gameResult: GameResult = .draw
//    var steps = 50
//    
//    init() {
//        Task {
//            await animateChart(delay: 0)
//            buttonDisabled = false
//        }
//        restart()
//    }
//    
//    func showFinishScreen() {
//        Task {
//            try? await Task.sleep(nanoseconds: 1_000_000_000)
//            withAnimation {
//                isFinishPresented = true
//            }
//        }
//    }
//    
//    private func moveUp(_ offset: Double = 50) {
//        let endPoint1 = maxY + offset
//        let endPoint2 = maxY - offset
//        chartData1.append(endPoint1)
//        chartData1.remove(at: 0)
//        chartData2.append(endPoint2)
//        chartData2.remove(at: 0)
//        minY = min(chartData1.min()!, chartData2.min()!) - 20
//        maxY = max(chartData1.max()!, chartData2.max()!) + 20
//    }
//    
//    private func moveDown(_ offset: Double = 50) {
//        let endPoint1 = minY - offset
//        let endPoint2 = minY + offset
//        chartData1.append(endPoint1)
//        chartData1.remove(at: 0)
//        chartData2.append(endPoint2)
//        chartData2.remove(at: 0)
//        minY = min(chartData1.min()!, chartData2.min()!) - 20
//        maxY = max(chartData1.max()!, chartData2.max()!) + 20
//    }
//    
//    func win() {
//        moveUp()
//        chartColor1 = .green
//        gameResult = .win
//        showFinishScreen()
//    }
//    
//    func lose() {
//        moveDown()
//        chartColor1 = .red
//        gameResult = .lose
//        showFinishScreen()
//    }
//    
//    func restart() {
//        buttonDisabled = false
//        isFinishPresented = false
//        chartColor1 = .blue
//    }
//    
//    private func animateChart(delay: Float = 0.05) async {
//        let stages1: [Int] = Array(Array(2..<steps - 2).shuffled().prefix(7))
//        let stages2: [Int] = Array(Array(2..<steps - 2).shuffled().prefix(15))
//        buttonDisabled = true
//        entryPoint1 = chartData1.last!
//        entryPoint2 = chartData2.last!
//        var currentEntryPoint1 = entryPoint1
//        var currentEntryPoint2 = entryPoint2
//        withAnimation {
//            chartColor1 = .blue
//        }
//        for i in 1..<steps {
//            if stages1.contains(i) {
//                currentEntryPoint1 += Double.random(in: -50...50)
//            }
//            if stages2.contains(i) {
//                currentEntryPoint2 += Double.random(in: -50...50)
//            }
//            chartData1.append(currentEntryPoint1 + Double.random(in: -3...3))
//            chartData1.remove(at: 0)
//            chartData2.append(currentEntryPoint2 + Double.random(in: -5...5))
//            chartData2.remove(at: 0)
//            minY = min(chartData1.min()!, chartData2.min()!) - 20
//            maxY = max(chartData1.max()!, chartData2.max()!) + 20
//            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
//        }
//    }
//    
//    func play() async {
//        await animateChart()
//        withAnimation {
//            Bool.random() ? win() : lose()
//        }
//    }
//}

import SwiftUI

@MainActor
final class CryptoViewModel: ObservableObject {
    @Published var chartDatas: [[Double]] = []
    @Published var chartColors: [Color] = []
    @Published var minY: Double = 0
    @Published var maxY: Double = 100
    @Published var entryPoints: [Double] = []
    @Published var buttonDisabled = false
    @Published var isFinishPresented = false
    @Published var gameResult: GameResult = .draw
    var steps = 50
    var numberOfCharts: Int // Adjust this number for more or fewer charts
    private var initialChartColors: [Color] = []
    
    let baseYValue: Double = 50
    let fluctuationRange: Double = 15

    init(numberOfCharts: Int = 1) {
        self.numberOfCharts = numberOfCharts
        setupCharts()
        Task {
            await animateChart(delay: 0)
            buttonDisabled = false
        }
        restart()
    }

    private func setupCharts() {
        chartColors.append(.orange)
        chartColors.append(.cyan)
        chartColors.append(.yellow)
        chartColors.append(.pink)
        chartColors.append(.gray)
        chartColors.append(.brown)
        chartColors.shuffle()
        chartColors.insert(.blue, at: 0)
        initialChartColors = chartColors
        for _ in 0..<numberOfCharts {
            let initialData = [Double](repeating: 0, count: 36)
            chartDatas.append(initialData)
            entryPoints.append(0)
        }
    }
    
    private func moveChart(_ chartIndex: Int, offset: Double) {
        let lastValue = chartDatas[chartIndex].last!
        let nextValue = lastValue + offset
        let boundedValue = max(minY, min(maxY, nextValue))
        chartDatas[chartIndex].append(boundedValue)
        chartDatas[chartIndex].remove(at: 0)
        updateMinMaxValues()
    }

    func showFinishScreen() {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                isFinishPresented = true
            }
        }
    }

    private func updateMinMaxValues() {
        minY = chartDatas.flatMap { $0 }.min()! - 20
        maxY = chartDatas.flatMap { $0 }.max()! + 20
    }

    func win() {
        for i in 0..<numberOfCharts {
//            moveChart(i, offset: 50)
            chartColors[i] = .green
        }
        gameResult = .win
        showFinishScreen()
    }
    
    func lose() {
        for i in 0..<numberOfCharts {
//            moveChart(i, offset: -50)
            chartColors[i] = .red
        }
        gameResult = .lose
        showFinishScreen()
    }

    func restart() {
        buttonDisabled = false
        isFinishPresented = false
        chartColors = initialChartColors
    }

    private func animateChart(delay: Float = 0.05) async {
        let stages: [[Int]] = (0..<numberOfCharts).map { _ in Array(Array(2..<steps - 2).shuffled().prefix(7)) }
        buttonDisabled = true
        
        for i in 0..<numberOfCharts {
            entryPoints[i] = chartDatas[i].last!
        }
        
        for step in 1..<steps {
            for i in 0..<numberOfCharts {
                
                if stages[i].contains(step) {
                    entryPoints[i] += Double.random(in: -50...50)
                }
                let offset = Double.random(in: -fluctuationRange...fluctuationRange)
                moveChart(i, offset: offset)
            }
            updateMinMaxValues()
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
    }

    func play() async {
        await animateChart()
        withAnimation {
            Bool.random() ? win() : lose()
        }
    }
}
