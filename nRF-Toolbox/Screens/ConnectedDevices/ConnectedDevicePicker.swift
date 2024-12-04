//
//  ConnectedDevicePicker.swift
//  nRF-Toolbox
//
//  Created by Dinesh Harjani on 3/12/24.
//  Copyright © 2024 Nordic Semiconductor. All rights reserved.
//

import SwiftUI
import iOS_Common_Libraries

// MARK: - ConnectedDevicePicker

struct ConnectedDevicePicker: View {
    
    // MARK: Environment
    
    @EnvironmentObject var connectedDevicesViewModel: ConnectedDevicesViewModel
    
    // MARK: view
    
    var body: some View {
        InlinePicker(title: "Device", selectedValue: $connectedDevicesViewModel.selectedDevice, possibleValues: connectedDevicesViewModel.connectedDevices)
            .labeledContentStyle(.accentedContent)
    }
}
