import SwiftUI
import SwiftData


struct Tag:Identifiable {
    var id: UUID = UUID()
    var title: String?
    var color: Color
    var icon: SFSymbol?
    
}

enum NodeType {
    case milestone
    case nagging
    case task
    
    var icon: SFSymbol {
        switch self {
        case .milestone:
            return SFSymbol.flag
        case .nagging:
            return SFSymbol.message
        case .task:
            return SFSymbol.clock
        }
        
    }
}

enum ValueType {
    case sum
    case average
    case max
    case min
}

struct Milestone:Identifiable {
    var id: UUID = UUID()
    var target: Int
    var source: Int
    var unit:String?;
    var label:String;
    var getValueType:ValueType
    
    func display() -> String {
        return "\(self.source)/\(self.target)"
    }
}

struct LineNode:Identifiable {
    var id: UUID = UUID()
    var createTime:Date
    var text:String
    var type: NodeType
    var endTime:Date?
}


struct TimeLine:Identifiable {
    var id:String {name}
    var name:String
    var icon: SFSymbol
    var nodes: [LineNode] = []
    var milestone:[Milestone] = []
    
}

struct IProject:Identifiable {
    var name:String
    var update:Date
    var icon:String
    var iconColor: Color
    var id:String {name}
    var tags: [Tag] = []
    var timeLines:[TimeLine] = []
}

let defaultProject =  [
    IProject(
        name: "里程碑",
        update: Date(),
        icon: "flag.checkered",
        iconColor: Color.accentColor,
        tags: [Tag(title: "技", color: Color.pink)],
        timeLines: [
            TimeLine(name: "运营推广",icon: SFSymbol.moon,
                     nodes: [
                        LineNode(createTime: Date(), text: "建立小红书账号", type: NodeType.milestone),
                        LineNode(createTime: Date(), text: "今天发布了一篇文章", type: NodeType.nagging),
                        LineNode(createTime: Date(), text: "明天准备写一篇关于独立开发入门的文章", type: NodeType.task),
                        LineNode(createTime: Date(), text: "小红书获得50个粉丝", type: NodeType.milestone),
                        LineNode(createTime: Date(), text: "累计发布20篇文案", type: NodeType.milestone)
                     ],
                     milestone: [
                        Milestone(target: 2000, source: 50, unit: "个",label:"粉丝", getValueType: ValueType.max),
                        Milestone(target: 100, source: 23, unit: "篇",label: "文章", getValueType: ValueType.max),
                        Milestone(target: 1000, source: 100, unit: "¥",label: "收入", getValueType: ValueType.max)
                     ]
                    ),
            TimeLine(name: "开发学习",icon: SFSymbol.moon,
                     nodes: [
                        LineNode(createTime: Date(), text: "学习swift ui", type: NodeType.milestone),
                        LineNode(createTime: Date(), text: "自定义tabbar", type: NodeType.nagging),
                        LineNode(createTime: Date(), text: "深色模式", type: NodeType.task),
                     ],
                     milestone: [
                        Milestone(target: 2000, source: 0, unit: "小时", label: "学习",getValueType: ValueType.sum)
                     ]
                    ),
            TimeLine(name: "产品设计",icon: SFSymbol.moon,
                     nodes: [
                        LineNode(createTime: Date(), text: "LOGO设计", type: NodeType.milestone),
                        LineNode(createTime: Date(), text: "制作启动闪页", type: NodeType.nagging),
                        LineNode(createTime: Date(), text: "构思多时间线模式", type: NodeType.task),
                     ],
                     milestone: [
                        Milestone(target: 20, source: 0, unit: "页", label: "设计",getValueType: ValueType.sum)
                     ]
                    )
        ]
    ),
    IProject(
        name: "100天完成一个App",
        update: Date(),
        icon: "sun.min",
        iconColor:Color.green,
        tags: [Tag(title: "学", color: Color.green)],
        timeLines: [
            TimeLine(
                name: "运营推广",
                icon: SFSymbol.book,
                nodes: [
                    LineNode(createTime: Date(), text: "建立小红书账号", type: NodeType.milestone),
                    LineNode(createTime: Date(), text: "今天发布了一篇文章", type: NodeType.nagging),
                    LineNode(createTime: Date(), text: "明天准备写一篇关于独立开发入门的文章", type: NodeType.task),
                    LineNode(createTime: Date(), text: "小红书获得50个粉丝", type: NodeType.milestone),
                    LineNode(createTime: Date(), text: "累计发布20篇文案", type: NodeType.milestone)
                ],
                milestone: [
                    Milestone(target: 2000, source: 0, unit: "小时", label: "学习",getValueType: ValueType.sum)
                ]),
            TimeLine(name: "开发学习",icon: SFSymbol.moon,
                     nodes: [
                        LineNode(createTime: Date(), text: "学习swift ui", type: NodeType.milestone),
                        LineNode(createTime: Date(), text: "自定义tabbar", type: NodeType.nagging),
                        LineNode(createTime: Date(), text: "深色模式", type: NodeType.task),
                     ],
                     milestone: [
                        Milestone(target: 2000, source: 0, unit: "小时", label: "学习",getValueType: ValueType.sum)
                     ]
                    )
        ]
    ),
    IProject(
        name: "百川 Baichuan",
        update: Date(),
        icon: "wind.snow",
        iconColor: Color.orange,
        tags: [Tag(title: "产品", color: Color.accentColor)],
        timeLines: [
            TimeLine(name: "运营推广",icon: SFSymbol.cloud, nodes: [
                LineNode(createTime: Date(), text: "建立小红书账号", type: NodeType.milestone),
                LineNode(createTime: Date(), text: "今天发布了一篇文章", type: NodeType.nagging),
                LineNode(createTime: Date(), text: "明天准备写一篇关于独立开发入门的文章", type: NodeType.task),
                LineNode(createTime: Date(), text: "小红书获得50个粉丝", type: NodeType.milestone),
                LineNode(createTime: Date(), text: "累计发布20篇文案", type: NodeType.milestone)
            ])
        ]
    ),
    IProject(
        name: "去拉萨",
        update: Date(),
        icon: "airplane",
        iconColor: Color.pink,
        tags: [Tag(title: "旅", color: Color.green,icon: SFSymbol.walk), Tag(title: "旅", color: Color.green)],
        timeLines: [
            TimeLine(name: "存钱计划",icon: SFSymbol.crown, nodes: [
                LineNode(createTime: Date(), text: "旅行资金累计2000", type: NodeType.milestone),
            ])
        ]
    ),
    
    IProject(
        name: "里程碑之约",
        update: Date(),
        icon: "fossil.shell",
        iconColor: Color.purple,
        tags: [
            Tag(title: "官", color: Color.orange),
            Tag(color: Color.accentColor,icon: SFSymbol.time)],
        timeLines: [
            TimeLine(name: "里程碑足迹",icon: SFSymbol.walk, nodes: [
                LineNode(createTime: Date(), text: "下载里程碑App", type: NodeType.milestone),
                LineNode(createTime: Date(), text: "创建一个项目", type: NodeType.nagging),
                LineNode(createTime: Date(), text: "使用里程碑7天", type: NodeType.task)
            ])
        ]
    )
]

class ProjectModel:ObservableObject {
    var projects:[IProject] = []
    
    init(){
        self.projects = defaultProject
    }
    init(projects: [IProject]) {
        self.projects = []
        for project in projects {
            self.projects.append(IProject(name: project.name,update: project.update,icon: project.icon,iconColor: project.iconColor,tags: project.tags))
        }
    }
    
    func count()-> Int{
        return self.projects.count
    }
    
}
