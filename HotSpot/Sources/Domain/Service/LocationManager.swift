import Foundation
import CoreLocation
import ComposableArchitecture
import Dependencies

struct LocationManager: DependencyKey {
    static var liveValue: LocationManager = .live
    
    var requestLocation: @Sendable () async -> CLLocation?
    
    static let live = Self(
        requestLocation: {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
            
            return await withCheckedContinuation { continuation in
                let delegate = LocationDelegate(continuation: continuation)
                manager.delegate = delegate
                manager.requestLocation()
                
                // Keep the delegate alive until the location is received
                _ = delegate
            }
        }
    )
}

private class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let continuation: CheckedContinuation<CLLocation?, Never>
    
    init(continuation: CheckedContinuation<CLLocation?, Never>) {
        self.continuation = continuation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        continuation.resume(returning: locations.first)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation.resume(returning: nil)
    }
}

extension DependencyValues {
    var locationManager: LocationManager {
        get { self[LocationManager.self] }
        set { self[LocationManager.self] = newValue }
    }
} 