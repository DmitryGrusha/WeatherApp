import Combine

final class MainViewModel: ObservableObject {
  
  let list: [FutureForecastModel] = [FutureForecastModel(id: 0, day: "test", minTemp: "1", maxTemp: "5", type: "lol"),
                                     FutureForecastModel(id: 1, day: "test1", minTemp: "1", maxTemp: "5", type: "lol"),
                                     FutureForecastModel(id: 2, day: "test2", minTemp: "1", maxTemp: "5", type: "lol"),
                                     FutureForecastModel(id: 3, day: "test3", minTemp: "1", maxTemp: "5", type: "lol"),
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
  
  func getFutureForecastData() {
    
  }
}
