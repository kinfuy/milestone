import SwiftUI



extension ScreenManage {
    var MianView: some View{
        VStack{
            switch currentTab {
            case .taday:
                Home()
            case .project:
                Project()
            case .me:
                Me()
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
    }
}


struct MyNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}

struct ScreenManage: View {
    @State var currentTab:TabbarEnum = .project
    @AppStorage("DarkMode") var userDarkMode:DarkMode = .system
    @State private var launchViewAlpha: CGFloat = 1
    var body: some View {
        ZStack {
            MyNavigation{
                ZStack(alignment: .bottom){
                    BgView()
                    MianView
                    Tabbar(selected: $currentTab)
                }
            }
            .opacity(launchViewAlpha == 1 ? 0 : 1)
            // 启动页
            LaunchView()
                .opacity(launchViewAlpha)
        }
        .onAppear {
            // 延迟 1 秒显示启动页
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                withAnimation(.easeInOut(duration: 1)) {
                    launchViewAlpha = 0
                }
            }
        }
        .preferredColorScheme(userDarkMode == DarkMode.system ? nil : userDarkMode.mode)
           
        
    }
}



struct ScreenManage_Previews: PreviewProvider {
    static var previews: some View {
        ScreenManage()
    }
}
