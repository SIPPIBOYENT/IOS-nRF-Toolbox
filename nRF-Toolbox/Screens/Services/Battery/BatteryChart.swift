//
//  BatteryChart.swift
//  nRF-Toolbox
//
//  Created by Nick Kibysh on 31/10/2023.
//  Copyright © 2023 Nordic Semiconductor. All rights reserved.
//

import SwiftUI
import CoreBluetoothMock_Collection
import Charts

// MARK: - BatteryChart

struct BatteryChart: View {
    
    // MARK: Properties
    
    let data: [ChartTimeData<Battery.Level>]
    let currentLevel: UInt?
    
    // MARK: view
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let currentLevel {
                    Text("Battery Level \(currentLevel)%")
                } else {
                    Text("Battery Level")
                }
            }
            .font(.title2.bold())
            
            chartView
        }
    }
    
    // MARK: chartView
    
    @ViewBuilder
    var chartView: some View {
        Chart(data, id: \.date) {
            BarMark(
                x: .value("Date", $0.date),
                y: .value("Battery Level", $0.value.level),
                width: .automatic,
                height: .automatic,
                stacking: .standard
            )
            .foregroundStyle(batteryStyle(level: $0.value.level))
        }
        .chartYAxis {
            AxisMarks(
                format: Decimal.FormatStyle.Percent.percent.scale(1),
                values: [0, 50, 100]
            )
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .minute)) 
        }
    }
    
    // MARK: batteryStyle(level:)
    
    private func batteryStyle(level: UInt) -> Color {
        switch level {
        case 0..<10: .red
        case 10..<20: .yellow
        default: .green
        }
    }
}
