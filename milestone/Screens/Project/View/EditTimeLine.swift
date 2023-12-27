
import SwiftUI
import MCEmojiPicker

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
                    id: timeLineId,
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
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text(emoji).font(.largeTitle)
                }).emojiPicker(
                    isPresented: $isPresented,
                    selectedEmoji: $emoji
                )
                .padding()
                .background(Color("BlueColor").opacity(0.1))
                .cornerRadius(8)
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
    
    @State private var timeLineId:UUID = UUID()
    @State private var lineTitle:String = ""
    @State private var emoji:String = "🗒️"
    @FocusState var focusedInput: String?
    
    @State var isPresented = false
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
        }.onAppear(){
            if let line = self.projectModel.editTimeLIne{
                lineTitle = line.name
                emoji = line.icon.rawvalue
                timeLineId = line.id
            }
            
        }
        .onDisappear(){
            self.projectModel.clearEdit()
        }
    }
}

