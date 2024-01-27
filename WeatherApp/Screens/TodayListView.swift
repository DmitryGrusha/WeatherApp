import SwiftUI

struct TodayListView: View {
  
  @Binding var model: MainModel?
  #warning("FIX LAYOUT")
  var body: some View {
    VStack {
        Text("Ожидается переменная облачность около 18:00")
          .font(Font.system(size: 14))
          .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
      Divider()
        .background(Color.gray)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
      ScrollView( .horizontal, showsIndicators: false) {
        HStack {
          ForEach(model?.todayList ?? [], id: \.timing) { item in
            TodayListItemView(item: item)
              .padding(.trailing, 16)
          }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
      }
      Spacer()
    }
    .background {
      BlurBackgroundView()
    }
  }
}

struct TodayListItemView: View {
  
  let item: TodayListModel
  
  var body: some View {
    VStack(spacing: 8) {
      Text(item.timing)
        .font(Font.system(size: 14, weight: .semibold))
      Image(systemName: item.image)
        .renderingMode(.original)
      Text(item.temp)
        .font(Font.system(size: 14, weight: .bold))
    }
  }
}
