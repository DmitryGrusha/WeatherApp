import Combine
import Foundation
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
  
  private let client = Client()
  private var locationManager = LocationManager()
  
  private let tempSymbol = "º"
  
  @Published var isAlertPresented: Bool = false
  
  @Published var model: MainModel?
  private var cancellables: Set<AnyCancellable> = []
  
  let todayList: [TodayListModel] = [TodayListModel(timing: "Сейчас", image: "sun.max.fill", temp: "-5º"),
                                     TodayListModel(timing: "16:25", image: "sunset.fill", temp: "Заход солнца"),
                                     TodayListModel(timing: "17", image: "moon.stars", temp: "-6º"),
                                     TodayListModel(timing: "18", image: "cloud.moon.fill", temp: "-6º"),
                                     TodayListModel(timing: "19", image: "moon.stars", temp: "-6º"),
                                     TodayListModel(timing: "20", image: "moon.stars", temp: "-7º"),
                                     TodayListModel(timing: "21", image: "cloud.moon.fill", temp: "-7º"),
                                     TodayListModel(timing: "22", image: "cloud.fill", temp: "-7º"),
                                     TodayListModel(timing: "23", image: "cloud.fill", temp: "-7º"),
                                     TodayListModel(timing: "00", image: "cloud.fill", temp: "-6º"),
                                     TodayListModel(timing: "01", image: "cloud.fill", temp: "-5º"),
                                     TodayListModel(timing: "02", image: "snowflake", temp: "-5º"),
                                     TodayListModel(timing: "03", image: "snowflake", temp: "-4º"),
                                     TodayListModel(timing: "04", image: "snowflake", temp: "-3º"),
                                     TodayListModel(timing: "05", image: "snowflake", temp: "-2º"),
                                     TodayListModel(timing: "06", image: "snowflake", temp: "-1º"),
                                     TodayListModel(timing: "07", image: "snowflake", temp: "0º"),
                                     TodayListModel(timing: "07:50", image: "sunrise.fill", temp: "Восход солнца"),
                                     TodayListModel(timing: "08", image: "cloud.fill", temp: "1º"),
                                     TodayListModel(timing: "09", image: "cloud.fill", temp: "2º"),
                                     TodayListModel(timing: "10", image: "cloud.fill", temp: "2º"),
                                     TodayListModel(timing: "11", image: "cloud.fill", temp: "2º"),
                                     TodayListModel(timing: "12", image: "cloud.fill", temp: "3º"),
                                     TodayListModel(timing: "13", image: "cloud.fill", temp: "3º"),
                                     TodayListModel(timing: "14", image: "cloud.fill", temp: "3º"),
                                     TodayListModel(timing: "15", image: "cloud.fill", temp: "3º"),
                                     TodayListModel(timing: "16", image: "cloud.fill", temp: "4º"),
  ]
  
  let futureForecast: [FutureForecastModel] = [FutureForecastModel(id: 0, day: "test", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 1, day: "test1", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 2, day: "test2", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 3, day: "test3", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 0, day: "test", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 1, day: "test1", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 2, day: "test2", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 3, day: "test3", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 2, day: "test2", minTemp: "1", maxTemp: "5", type: "lol"),
                                               FutureForecastModel(id: 3, day: "test3", minTemp: "1", maxTemp: "5", type: "lol")
  ]
  
  
  func setupLocationManager() {
    locationManager.$currentLocation
      .compactMap { $0 }
      .sink { [weak self] coordinates in
        self?.getCurrent(latitude: coordinates.latitude , longiture: coordinates.longitude )
      }
      .store(in: &cancellables)
    locationManager.$isAlertPresented
      .compactMap { $0 }
      .sink { [weak self] value in
        self?.isAlertPresented = value
      }
      .store(in: &cancellables)
  }
  
  
  
  private func getCurrent(latitude: Double, longiture: Double) {
    if model == nil {
      guard var components = URLComponents(string: APIGlobals.apiUrl + APIRoute.forecast.url) else { return }
      components.queryItems = [URLQueryItem(name: "key", value: APIGlobals.apiKey),
                               URLQueryItem(name: "q", value: "\(latitude)" + "," + "\(longiture)"),
                               URLQueryItem(name: "days", value: "2")
      ]
      guard let url = components.url else { return }
      let request = URLRequest(url: url)
      Task {
        do {
          let response = try await client.fetch(type: CurrentLocationResponseModel.self, with: request)
          fillInMainModel(data: response)
          
        } catch {
          print("\((error as! ApiError).customDescription)")
        }
      }
    }
  }
  
  private func fillInMainModel(data: CurrentLocationResponseModel) {
    var maxTemp = "0" + tempSymbol
    var minTemp = "0" + tempSymbol
    if !data.forecast.forecastday.isEmpty {
      if let today = data.forecast.forecastday.first {
        maxTemp = "Max: " + String(today.day.maxTempC) + tempSymbol + ", "
        minTemp = "Min: " + String(today.day.minTempC) + tempSymbol
      }
    }
    
    model = MainModel(locationName: data.location.name,
                      currentTemp: String(data.current.tempC) + tempSymbol,
                      currentCondition: data.current.condition.text,
                      todayMaxTemp: maxTemp,
                      todayMinTemp: minTemp,
                      todayList: fillInTodayList(data: data)
    )
  }
  
  private func fillInTodayList(data: CurrentLocationResponseModel) -> [TodayListModel] {
    var result: [TodayListModel] = []
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    var maxResultCount: Int = 24
    var sunriseSet: Bool = false
    var sunsetSet: Bool = false
    if !data.forecast.forecastday.isEmpty {
      data.forecast.forecastday.forEach { day in
        day.hour.forEach { hour in
          if result.count == maxResultCount { return }
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          if let date = dateFormatter.date(from: hour.time) {
            let calendar = Calendar.current
            let hourComponent = calendar.component(.hour, from: date)
            let currentHourComponent = calendar.component(.hour, from: currentDate)
            if currentHourComponent == hourComponent {
              let item = TodayListModel(timing: "Now", image: "", temp: String(hour.tempC) + tempSymbol)
              result.append(item)
            }
            if currentDate < date {
//              print(String(hourComponent))
//              print("--------------")
              let item = TodayListModel(timing: String(hourComponent), image: hour.condition.text, temp: String(hour.tempC) + tempSymbol)
              result.append(item)
            }
          }
          
          // Sunrise, sunset
          if let hourDate = dateFormatter.date(from: hour.time) {
            if !sunriseSet {
              let sunrise = setSunrise(date: hourDate, day: day)
              if sunrise.0 {
                maxResultCount += 1
                sunriseSet = true
                if let sunriseItem = sunrise.1 {
                  result.append(sunriseItem)
                }
              }
            }
            if !sunsetSet {
              let sunset = setSunset(date: hourDate, day: day)
              if sunset.0 {
                maxResultCount += 1
                sunsetSet = true
                if let sunsetItem = sunset.1 {
                  result.append(sunsetItem)
                }
              }
            }
          }
        }
      }
    }
    return result
  }
  
  
  private func setSunrise(date: Date, day: Forecastday) -> (Bool, TodayListModel?) {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    if let sunriseDate = dateFormatter.date(from: day.astro.sunrise) {
      dateFormatter.dateFormat = "HH:mm"
      let currentTime = dateFormatter.string(from: currentDate)
      let sunriseTime = dateFormatter.string(from: sunriseDate)
      let dateTime = dateFormatter.string(from: date)
      
      if let currentDateTime = dateFormatter.date(from: currentTime),
         let sunriseDateTime = dateFormatter.date(from: sunriseTime),
         let dateTimeFormatted = dateFormatter.date(from: dateTime) {
        let calendar = Calendar.current
        let dateHour = calendar.component(.hour, from: dateTimeFormatted)
        let sunriseHour = calendar.component(.hour, from: sunriseDateTime)
        
        if dateTimeFormatted < sunriseDateTime && sunriseHour == dateHour{
          let dateHour = calendar.component(.hour, from: date)
          let dateMinutes = calendar.component(.minute, from: date)
          let currentHour = calendar.component(.hour, from: currentDate)
//          if dateHour == currentHour {
            return (true, TodayListModel(timing: "\(dateHour):\(dateMinutes)", image: "", temp: "Sunrise"))
//          }
        }
      }
      
//      if currentTime < sunriseTime{
//        let calendar = Calendar.current
//        let dateHour = calendar.component(.hour, from: date)
//        let dateMinutes = calendar.component(.minute, from: date)
//        let currentHour = calendar.component(.hour, from: currentDate)
//        if dateHour == currentHour {
//          return (true, TodayListModel(timing: "\(dateHour):\(dateMinutes)", image: "", temp: "Sunrise"))
//        }
//      }
    }
    return (false, nil)
  }
  
  private func setSunset(date: Date, day: Forecastday) -> (Bool, TodayListModel?) {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    if let sunsetDate = dateFormatter.date(from: day.astro.sunset) {
      if currentDate < sunsetDate {
        let calendar = Calendar.current
        let dateHour = calendar.component(.hour, from: date)
        let dateMinutes = calendar.component(.minute, from: date)
        let currentHour = calendar.component(.hour, from: currentDate)
        if dateHour == currentHour {
          return (true, TodayListModel(timing: "\(dateHour):\(dateMinutes)", image: "", temp: "Sunset"))
        }
      }
    }
    return (false, nil)
  }
}
