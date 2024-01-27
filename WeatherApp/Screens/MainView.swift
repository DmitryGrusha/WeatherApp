import SwiftUI

struct MainView: View {
  @StateObject private var viewModel = MainViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        CurrentInfoView(model: $viewModel.model)
        TodayListView(model: $viewModel.model)
          .padding(.leading, 20)
          .padding(.trailing, 20)
      }
    }
    .background {
      Image("sunny1")
    }
    .onAppear {
      viewModel.setupLocationManager()
    }
    .alert(isPresented: $viewModel.isAlertPresented) {
      Alert(
          title: Text("Location Access Denied"),
          message: Text("Please enable location access in the Settings app to use this feature."),
          primaryButton: .default(Text("Open Settings"), action: {
              if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                  UIApplication.shared.open(settingsURL)
              }
          }),
          secondaryButton: .cancel()
      )
    }
  }
  
}
