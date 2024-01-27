import Foundation

protocol GenericAPI {
 var session: URLSession { get }
 func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T
}

extension GenericAPI {
 func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T {
  let (data, response) = try await session.data(for: request)
  guard let httpResponse = response as? HTTPURLResponse else {
   throw ApiError.requestFailed(description: "Invalid response")
  }
  guard httpResponse.statusCode == 200 else {
   throw ApiError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
  }
  do {
    let results = try JSONDecoder().decode(type, from: data)
    return results
  } catch {
   throw ApiError.jsonConversionFailure(description: error.localizedDescription)
  }
 }
}
