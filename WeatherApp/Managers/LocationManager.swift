import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private var locationManager = CLLocationManager()
  
  @Published var currentLocation: CLLocationCoordinate2D?
  @Published var isAlertPresented: Bool = false

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  private func checkLocationAuthorizationStatus() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      requestLocationAuthorization()
    case .restricted, .denied:
      requestLocationAuthorization()
      isAlertPresented = true
    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.startUpdatingLocation()
    @unknown default:
      break
    }
  }
  
  private func requestLocationAuthorization() {
      locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      checkLocationAuthorizationStatus()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first?.coordinate {
      currentLocation = location
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Ошибка при получении локации: \(error.localizedDescription)")
  }
}
