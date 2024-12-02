//
//  RootNavigationScreen.swift
//  nRF-Toolbox
//
//  Created by Nick Kibysh on 16/11/2023.
//  Copyright © 2023 Nordic Semiconductor. All rights reserved.
//

import SwiftUI
import iOS_BLE_Library_Mock

struct RootNavigationView: View {

    // MARK: Properties
    
    private static let centralManager = CentralManager()
    
    @StateObject var viewModel = RootNavigationViewModel.shared
    @StateObject var connectedDevicesViewModel = ConnectedDevicesViewModel(centralManager: centralManager)
    
    @StateObject var scannerViewModel = PeripheralScannerScreen.PeripheralScannerViewModel(centralManager: centralManager)

    @State private var visibility: NavigationSplitViewVisibility = .all
    @State private var compactPreferredColumn: NavigationSplitViewColumn = .sidebar
    
    // MARK: view
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility, preferredCompactColumn: $compactPreferredColumn) {
            SidebarView()
                .environmentObject(connectedDevicesViewModel)
        } content: {
            PeripheralScannerScreen()
                .environmentObject(connectedDevicesViewModel)
                .environmentObject(scannerViewModel)
        } detail: {
            if let deviceId = viewModel.selectedDevice {
                if let deviceVM = connectedDevicesViewModel.deviceViewModel(for: deviceId) {
                    DeviceDetailsScreen(viewModel: deviceVM)
                        .environmentObject(connectedDevicesViewModel)
                } else {
                    NoContentView(title: "Device is not connected", systemImage: "laptopcomputer.slash")
                }
            } else {
                NoContentView(title: "Device is not selected", systemImage: "laptopcomputer.slash")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .accentColor(.white)
        .environmentObject(viewModel)
    }
}
