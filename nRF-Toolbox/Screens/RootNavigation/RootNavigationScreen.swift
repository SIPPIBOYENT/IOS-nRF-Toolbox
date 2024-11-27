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

    @StateObject var viewModel = RootNavigationViewModel.shared
    @StateObject var connectedDevicesViewModel = ConnectedDevicesViewModel()
    
    @StateObject var scannerViewModel = PeripheralScannerScreen.PeripheralScannerViewModel(centralManager: CentralManager())

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(connectedDevicesViewModel)
        } content: {
            ConnectedDevicesScreen()
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
        .accentColor(.white)
        .environmentObject(viewModel)
    }
}
