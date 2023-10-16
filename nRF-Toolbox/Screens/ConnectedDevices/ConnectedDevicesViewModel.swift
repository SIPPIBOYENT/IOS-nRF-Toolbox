//
//  ConnectedDevicesViewModel.swift
//  nRF-Toolbox
//
//  Created by Nick Kibysh on 11/10/2023.
//  Copyright © 2023 Nordic Semiconductor. All rights reserved.
//

import SwiftUI
import iOS_BLE_Library_Mock
import Combine

extension ConnectedDevicesScreen {
    @MainActor
    class ViewModel: ObservableObject {
        typealias ScannerVM = PeripheralScannerScreen.ViewModel
        
        private var deviceViewModels: [UUID: DeviceDetailsScreen.ViewModel] = [:]
        private var cancelable = Set<AnyCancellable>()
        
        private (set) lazy var environment: Environment = Environment(deviceViewModel: { [unowned self] in self.deviceViewModel(for: $0) })
        let centralManager: CentralManager
        
        private (set) lazy var scannerViewModel: ScannerVM! = ScannerVM(centralManager: centralManager)
        
        init(centralManager: CentralManager = CentralManager()) {
            self.centralManager = centralManager
            
            observeConnections()
            observeDisconnections()
        }
    }
}

extension ConnectedDevicesScreen.ViewModel {
    private func deviceViewModel(for device: Device) -> DeviceDetailsScreen.ViewModel {
        if let vm = deviceViewModels[device.id] {
            return vm
        } else {
            guard let peripheral = centralManager.retrievePeripherals(withIdentifiers: [device.id]).first else {
                fatalError()
            }
            let newViewModel = DeviceDetailsScreen.ViewModel(cbPeripheral: peripheral)
            deviceViewModels[device.id] = newViewModel
            return newViewModel
        }
    }
}

extension ConnectedDevicesScreen.ViewModel {
    private func observeConnections() {
        centralManager.connectedPeripheralChannel
            .filter { $0.1 == nil } // No connection error
            .map { Device(name: $0.0.name, id: $0.0.identifier) }
            .sink { [unowned self] device in
                self.environment.connectedDevices.replacedOrAppended(device)
            }
            .store(in: &cancelable)
    }
    
    private func observeDisconnections() {
        centralManager.disconnectedPeripheralsChannel
            .sink { [unowned self] device in
                guard let deviceIndex = self.environment.connectedDevices.firstIndex(where: { $0.id == device.0.identifier }) else {
                    return
                }
                
                if let err = device.1 {
                    // TODO: Show that the device was disconnected unexpectadly
                } else {
                    self.environment.connectedDevices.remove(at: deviceIndex)
                }
            }
            .store(in: &cancelable)
    }
}

extension ConnectedDevicesScreen.ViewModel {
    struct Device: Identifiable, Equatable {
        let name: String?
        let id: UUID
        
        static func == (lhs: Device, rhs: Device) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    class Environment: ObservableObject {
        @Published var showScanner: Bool = false
        
        @Published fileprivate (set) var connectedDevices: [Device]
        
        let deviceViewModel: ((Device) -> (DeviceDetailsScreen.ViewModel))?
        
        init(
            connectedDevices: [Device] = [],
            deviceViewModel: ((Device) -> (DeviceDetailsScreen.ViewModel))? = nil
        ) {
            self.connectedDevices = connectedDevices
            self.deviceViewModel = deviceViewModel
        }
    }
}