//
//  SidebarScreen.swift
//  nRF-Toolbox
//
//  Created by Nick Kibysh on 14/11/2023.
//  Copyright © 2023 Nordic Semiconductor. All rights reserved.
//

import SwiftUI

// MARK: - SidebarView

struct SidebarView: View {
    
    // MARK: Environment
    
    @EnvironmentObject var rootViewModel: RootNavigationViewModel
    @EnvironmentObject var viewModel: ConnectedDevicesViewModel
    
    // MARK: view
    
    var body: some View {
        List(selection: $rootViewModel.selectedCategory) {
            Section("Connected Devices") {
                // +1 for "Unselected".
                if viewModel.connectedDevices.count < 2 {
                    Text("No Connected Devices")
                } else {
                    ForEach(viewModel.connectedDevices) { device in
                        if device != .Unselected {
                            ConnectedDeviceView(device)
                                .tag(RootNavigationView.MenuCategory.device)
                        }
                    }
                }
            }
            
            Section {
                Text("Open Scanner")
                    .foregroundStyle(Color.universalAccentColor)
                    .centered()
                    .tag(RootNavigationView.MenuCategory.scanner)
            }
            
            Section("Other") {
                Text("About nRF Toolbox")
                    .tag(RootNavigationView.MenuCategory.about)
                    .disabled(true)
            }
        }
        .navigationTitle("nRF Toolbox")
        .setupNavBarBackground(with: Assets.navBar.color)
    }
}
