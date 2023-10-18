
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
            Text("新建节点").fontWeight(.bold)
            Spacer()
            Button("完成", action: {
                if(self.projectId != nil){
//                    store.addNode(projectId: self.projectId!, timeLineId: self.timeLineId, node: LineNode(createTime: Date(), text: self.nodeTitle, type: self.nodeType))
                }
                
                self.$state.wrappedValue.toggle()
            })
        }
        .padding(.vertical)
    }
    
    var ContentView: some View{
        VStack{
            TitleView(title: "节点名称")
            VStack{
                TextField("标题", text: self.$nodeTitle)
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
                        Text("描述往往是长脑子的过程🤔")
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
    
    var NodeTypeView: some View {
        VStack{
            TitleView(title: "节点配置")
            VStack{
                HStack{
                    Picker(selection: self.$nodeType, content: {
                        ForEach(NodeType.allCases, id:\.rawValue){item in
                            Text(item.text).tag(item)
                        }
                    }, label: {
                        HStack{
                            Text("节点类型")
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .selection()
        }
    }
    
    var TaskNodeContentView:some View {
        VStack{
            DatePicker("开始日期", selection:   self.$startTime,displayedComponents: [.date])
            DatePicker("结束日期", selection:   self.$endTime,displayedComponents: [.date])
            HStack{
                Text("持续")
                Spacer()
                TextField("", text: self.$daysCount)
                    .labelsHidden()
                    .textFieldStyle(.plain)
                    .keyboardType(.numberPad)
                    .frame(width: 120)
                Text("天")
            }
            
        }
        .selection()
    }
    
    
}

struct EditTimeLine:View {
    
    @EnvironmentObject var store: ProjectModel
    @Binding var state:Bool
    
    @State var timeLineId:UUID
    @State private var projectId:String?
    @State private var nodeTitle:String = ""
    @State private var nodeDescription = ""
    @State private var startTime:Date =  Date()
    @State private var endTime:Date =  Date()
    @State private var daysCount = "1"
    @State private var nodeType:NodeType = .nagging
    @FocusState var focusedInput: String?
    var body: some View {
        ZStack{
            BgView()
            VStack{
                NavView
                ScrollView(content: {
                    ContentView
                    NodeTypeView
                    switch nodeType {
                    case .task:
                        TaskNodeContentView
                    case .milestone:
                        TaskNodeContentView
                    case .nagging:
                        VStack{}
                    }
                })
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

