
import SwiftUI

extension EditTimeLine {
    struct TitleView:View {
        var title:String
        var body: some View{
            HStack{
                Text(title).font(.headline).fontWeight(.bold).foregroundColor(Color.secondary)
                Spacer()
            }
        }
    }
    var NavView:some View {
        HStack{
            Button("取消", action: {
                self.$state.wrappedValue.toggle()
            })
            Spacer()
            Text("时间线").fontWeight(.bold)
            Spacer()
            Button("完成", action: {
                let timeline = TimeLine(
                    id: UUID(),
                    name: self.lineTitle,
                    icon: Icon(emoji: self.emoji),
                    create: Date(),
                    update: Date()
                )
                self.projectModel.addTimeLine(timeLine: timeline)
                self.$state.wrappedValue.toggle()
                self.close()
            })
        }
        .padding(.vertical)
    }
    
    var ContentView: some View{
        VStack{
            TitleView(title: "时间线名称")
            VStack{
                EmojiTextField(text: $emoji ,size: 42)
                    .onChange(of: self.emoji){
                        newValue in
                        if(newValue.count>1){
                            self.emoji = String(newValue.suffix(1))
                        }
                        if(!self.emoji.isEmoji){
                            self.emoji = "🗒️"
                        }
                    }
                    .frame(width: 48,height: 48)
                Divider()
                TextField("标题", text: self.$lineTitle)
                    .focused($focusedInput, equals: "nodeTitle" )
                
            }
            .selection()
            .padding(.bottom)
            
        }
    }
    
    
}

struct EditTimeLine:View {
    
    @EnvironmentObject var projectModel: ProjectModel
    @Binding var state:Bool
    
    var close:()-> Void
    @State private var lineTitle:String = ""
    @State private var emoji:String = "🗒️"
    @FocusState var focusedInput: String?
    var body: some View {
        ZStack{
            BgView()
            VStack{
                NavView
                ScrollView(content: {
                    ContentView
                })
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

