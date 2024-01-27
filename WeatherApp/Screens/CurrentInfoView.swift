import SwiftUI

struct CurrentInfoView: View {
  
  @Binding var model: MainModel?
  
  var body: some View {
    VStack {
      Text(model?.locationName ?? "")
        .font(Font.system(size: 40))
      Text(model?.currentTemp ?? "")
        .font(Font.system(size: 70))
      Text(model?.currentCondition ?? "")
        .font(Font.system(size: 20))
      Text((model?.todayMaxTemp ?? "") + ", " + (model?.todayMinTemp ?? ""))
        .font(Font.system(size: 18))
    }
  }
}
