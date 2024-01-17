import SwiftUI

struct MainView: View {
  private var viewModel = MainViewModel()
  
  var body: some View {
    ZStack {
      VStack(spacing: 12) {
        TodayListView()
        FutureForecastView()
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
