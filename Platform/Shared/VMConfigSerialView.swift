//
// Copyright © 2022 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14, macOS 11, *)
struct VMConfigSerialView: View {
    @Binding var config: UTMQemuConfigurationSerial
    @Binding var system: UTMQemuConfigurationSystem
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Connection")) {
                    VMConfigConstantPicker("Mode", selection: $config.mode)
                        .onChange(of: config.mode) { newValue in
                            if newValue == .builtin && config.terminal == nil {
                                config.terminal = .init()
                            }
                        }
                    VMConfigConstantPicker("Target", selection: $config.target)
                }
                
                if config.target == .manualDevice {
                    Section(header: Text("Hardware")) {
                        VMConfigConstantPicker("Emulated Serial Device", selection: $config.hardware, type: system.architecture.serialDeviceType)
                    }
                }
                
                if config.mode == .builtin {
                    VMConfigDisplayConsoleView(config: $config.terminal.bound)
                } else if config.mode == .tcpClient || config.mode == .tcpServer {
                    Section(header: Text("TCP")) {
                        if config.mode == .tcpClient {
                            DefaultTextField("Server Address", text: $config.tcpHostAddress.bound, prompt: "example.com")
                                .keyboardType(.decimalPad)
                        }
                        NumberTextField("Port", number: $config.tcpPort.bound, prompt: "1234")
                    }
                }
            }
        }.disableAutocorrection(true)
        #if !os(macOS)
        .padding(.horizontal, 0)
        #endif
    }
}

@available(iOS 14, macOS 11, *)
struct VMConfigSerialView_Previews: PreviewProvider {
    @State static private var config = UTMQemuConfigurationSerial()
    @State static private var system = UTMQemuConfigurationSystem()
    
    static var previews: some View {
        VMConfigSerialView(config: $config, system: $system)
    }
}