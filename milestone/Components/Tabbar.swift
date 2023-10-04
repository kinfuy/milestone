import SwiftUI

enum TabbarEnum: String, CaseIterable {
    case taday  = "今日摘要"
    case project = "我的项目"
    case me = "设置"
    
    var iconName: SFSymbol {
        switch self {
        case .taday:
            return SFSymbol.home
        case .project:
            return SFSymbol.project
        case .me:
            return SFSymbol.set
        }
        
    }
}

struct Tabbar: View {
    @Binding var selected: TabbarEnum
    
    func getColor(name:TabbarEnum)->Color {
        if(selected == name){
            return Color.accentColor
        }
        return Color.gray
    }
    
    var body: some View {
        HStack(spacing:0){
            ForEach(TabbarEnum.allCases,id:\.rawValue) { item in
               Button(action: {
                   selected = item
               }, label: {
                   VStack{
                       item.iconName
                           .resizable()
                           .scaledToFit()
                           .frame(width: 24)
                       Text(item.rawValue).font(.system(size: 12,weight: .bold))
                   }.frame(maxWidth:.infinity)
               })
               .foregroundColor(getColor(name: item))
            }
        }
        .padding(.top, 14)
        .frame(height: 88, alignment: .top)
        .background(Color("WriteColor"))
        .frame(maxHeight: .infinity,alignment: .bottom)
        .ignoresSafeArea()
    }
}

