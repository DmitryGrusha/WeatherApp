import Foundation

enum APIRoute {
  case current
  case forecast
  case search
  case history
  case marine
  case future
  case timeZone
  case sports
  case astronomy
  
  var url: String {
    switch self {
    case .current:
      return "/current.json"
    case .forecast:
      return "/forecast.json"
    case .search:
      return "/search.json"
    case .history:
      return "/history.json"
    case .marine:
      return "/marine.json"
    case .future:
      return "/future.json"
    case .timeZone:
      return "/timezone.json"
    case .sports:
      return "/sports.json"
    case .astronomy:
      return "/astronomy.json"
    }
  }
}
