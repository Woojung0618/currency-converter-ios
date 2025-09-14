import Foundation
import UIKit

// MARK: - 메모리 관리 유틸리티
class MemoryManager {
    static let shared = MemoryManager()
    
    private init() {}
    
    // 메모리 사용량 모니터링
    func getMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return info.resident_size
        } else {
            return 0
        }
    }
    
    // 메모리 사용량을 MB로 변환
    func getMemoryUsageMB() -> Double {
        return Double(getMemoryUsage()) / 1024.0 / 1024.0
    }
    
    // 메모리 경고 알림
    func checkMemoryWarning() {
        let memoryUsage = getMemoryUsageMB()
        
        // 100MB 이상 사용 시 경고
        if memoryUsage > 100.0 {
            print("⚠️ High memory usage: \(String(format: "%.2f", memoryUsage)) MB")
            
            // 메모리 정리 권장
            cleanupMemory()
        }
    }
    
    // 메모리 정리
    func cleanupMemory() {
        // 이미지 캐시 정리
        URLCache.shared.removeAllCachedResponses()
        
        // 알림 센터에서 불필요한 옵저버 제거
        NotificationCenter.default.removeObserver(self)
        
        print("🧹 Memory cleanup completed")
    }
    
    // 메모리 압박 상황 감지
    func setupMemoryWarningObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            print("🚨 Memory warning received!")
            self.cleanupMemory()
        }
    }
    
    // 옵저버 제거
    func removeMemoryWarningObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        removeMemoryWarningObserver()
    }
}

// MARK: - 메모리 최적화를 위한 확장
extension UIApplication {
    func optimizeMemoryUsage() {
        // 백그라운드로 전환될 때 메모리 정리
        MemoryManager.shared.cleanupMemory()
    }
}
