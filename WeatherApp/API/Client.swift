import Foundation

final class Client: GenericAPI {

 let session: URLSession

 init(configuration: URLSessionConfiguration) {
  self.session = URLSession(configuration: configuration)
 }

 convenience init() {
  self.init(configuration: .default)
 }
}
