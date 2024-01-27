import SwiftUI

struct FutureForecastView: View {
//  private var viewModel = MainViewModel()
  
  var body: some View {
    Text("")
//    List(viewModel.futureForecast, id: \.id) { item in
//      FutureForecastItem(item: item)
//    }
  }
}

private struct FutureForecastItem: View {
  let item: FutureForecastModel
  
  var body: some View {
    HStack {
      Text(item.day)
      Spacer()
      HStack {
        Text(item.minTemp)
        Text(item.maxTemp)
      }
    }
    .onAppear()
  }
  
}


struct FutureForecast_Previews: PreviewProvider {
  static var previews: some View {
    FutureForecastView()
  }
}
