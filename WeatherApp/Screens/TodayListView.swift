import SwiftUI

struct TodayListView: View {
  var body: some View {
    ZStack {
      VStack {
        Text("Ожидается переменная облачность около 18:00")
        Divider()
          .padding(.leading, 10)
          .padding(.trailing, 10)
      }
    }
  }
}

struct TodayListView_Previews: PreviewProvider {
  static var previews: some View {
    TodayListView()
  }
}
