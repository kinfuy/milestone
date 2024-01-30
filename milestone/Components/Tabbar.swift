import SwiftUI

enum TabbarEnum: String, CaseIterable {
//    case taday  = "摘要"
    case project = "项目"
//    case warehouse = "仓库"
    case me = "设置"
   
    
    var iconName: SFSymbol {
        switch self {
//        case .taday:
//            return SFSymbol.home
        case .project:
            return SFSymbol.book
        case .me:
            return SFSymbol.set
//        case .warehouse:
//            return SFSymbol.warehouse
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

