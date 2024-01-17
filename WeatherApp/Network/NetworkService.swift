import Foundation

final class NetworkService {
  static let shared = NetworkService()
  private init() {}
  
  private let session = URLSession.shared.configuration
}
