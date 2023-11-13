
import SwiftUI

extension EditNode {
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
            Text(self.projectModel.editNode!.type.text).fontWeight(.bold)
            Spacer()
            Button("完成", action: {
              
                let staus:NodeStatus = self.projectModel.editNode!.type == .task ? .notStart : .unowned
                let node = LineNode(
                    id: nodeId,
                    title: self.nodeTitle,
                    type: self.projectModel.editNode!.type,
                    create: Date(),
                    update: Date(),
                    content: self.nodeDescription,
                    startTime:self.start,
                    endTime:self.end, status:staus)
                self.projectModel.addNode(node: node)
                self.state = false
                self.close()
            })
        }
        .padding(.vertical)
    }
    
    var ContentView: some View{
        VStack{
            TitleView(title: "基础")
            VStack{
                TextField("名称", text: self.$nodeTitle)
                    .focused($focusedInput, equals: "nodeTitle" )
                Divider()
                ZStack(alignment: .topLeading){
                    ZStack(alignment: .bottomTrailing){
                        TextEditor(text: self.$nodeDescription)
                            .focused($focusedInput, equals: "nodeDescription")
                            .lineSpacing(8)
                            .autocapitalization(.words).disableAutocorrection(true)
                        
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: 180
                            )
                    }
                    if(self.nodeDescription.isEmpty){
                        Text("描述往往是长脑子的过程")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.vertical,12)
                            .onTapGesture {
                                self.$focusedInput.wrappedValue = "nodeDescription"
                            }
                    }
                }
                
                Spacer()
            }
            .frame(width: .infinity,height: 160)
            .selection()
            .padding(.bottom)
            
        }
    }
    
    
    var SeniorConfigView: some View {
        VStack{
            Toggle(isOn: $seniorStatus, label: {
                TitleView(title: "高级")
            })
            if(seniorStatus){
                switch self.projectModel.editNode?.type {
                case .task:
                    DatePicker("开始时间", selection: $start)
                    DatePicker("开始时间", selection: $end)
                default:
                    EmptyView()
                }
            }
        }
    }
    
    
}

struct EditNode:View {
    
    @EnvironmentObject var projectModel: ProjectModel
    @Binding var state:Bool
    
    var close:()-> Void
    
    @State var timeLineId:UUID?
    @State private var projectId:UUID?
    @State private var nodeId:UUID = UUID()
    @State private var nodeTitle:String = ""
    @State private var nodeDescription = ""
    @State private var seniorStatus:Bool = false  // 是否开启高级配置
    @State private var start:Date = Date()
    @State private var end:Date = Date()
    @FocusState var focusedInput: String?
    var body: some View {
        ZStack{
            BgView()
            VStack{
                NavView
                ScrollView(content: {
                    ContentView
                    if(self.projectModel.editNode?.type != .nagging){
                        SeniorConfigView
                    }
                    
                })
                Spacer()
            }
            .padding(.horizontal)
        }.onAppear(){
            if let node = self.projectModel.editNode{
                nodeTitle = node.title
                nodeDescription = node.content ?? ""
                start = node.startTime ?? Date()
                end = node.endTime ?? Date()
                nodeId = node.id
                seniorStatus = self.projectModel.nodeSenior
            }
            
        }
        .onDisappear(){
            self.projectModel.clearEdit()
        }
    }
}

