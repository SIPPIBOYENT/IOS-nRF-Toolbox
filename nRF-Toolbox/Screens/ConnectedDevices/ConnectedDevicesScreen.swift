//
//  ConnectedDevicesView.swift
//  nRF-Toolbox
//
//  Created by Nick Kibysh on 07/07/2023.
//  Copyright © 2023 Nordic Semiconductor. All rights reserved.
//

import SwiftUI
import iOS_Common_Libraries

struct ConnectedDevicesScreen: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ConnectedDevicesView {
            NavigationStack {
                PeripheralScannerScreen(viewModel: viewModel.scannerViewModel)
#if os(macOS)
                    .frame(minWidth: 400, minHeight: 450)
#endif
            }
        }
        .environmentObject(viewModel.environment)
    }
}

struct ConnectedDevicesView<ScannerScreen: View> : View {
    @EnvironmentObject var environment: ConnectedDevicesScreen.ViewModel.Environment
    @State var selectedService: String?
    
    let scannerScreen: () -> ScannerScreen
    
    init(
        @ViewBuilder scannerScreen: @escaping () -> ScannerScreen
    ) {
        self.scannerScreen = scannerScreen
    }
    
    var body: some View {
        VStack {
            if environment.connectedDevices.isEmpty {
                ConnectedDevicesScreen.InitialStace()
                    .padding()
                    .environmentObject(environment)
            } else {
                ConnectedDeviceList()
            }
        }
        .sheet(isPresented: $environment.showScanner, content: scannerScreen)
    }
}

#Preview {
    NavigationStack {
        ConnectedDevicesView {
            EmptyView()
        }
        .environmentObject(ConnectedDevicesScreen.ViewModel.Environment(connectedDevices: [
            ConnectedDevicesScreen.ViewModel.Device(name: "Device 1", id: UUID())
        ]))
    }
}

#Preview {
    NavigationStack {
        ConnectedDevicesView {
            EmptyView()
        }
        .environmentObject(ConnectedDevicesScreen.ViewModel.Environment(connectedDevices: []))
    }
}
