//
//  currency_converter_appApp.swift
//  currency-converter-app
//
//  Created by 전우정 on 8/10/25.
//

import SwiftUI

@main
struct currency_converter_appApp: App {
    
    init() {
        // 메모리 관리자 초기화
        MemoryManager.shared.setupMemoryWarningObserver()
        
        // 앱 시작 시 메모리 사용량 확인
        MemoryManager.shared.checkMemoryWarning()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // 시스템 다크모드 설정을 따름
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                    // 메모리 경고 시 정리
                    MemoryManager.shared.cleanupMemory()
                }
        }
    }
}
