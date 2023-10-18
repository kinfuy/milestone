
import SwiftUI



struct Tag:Identifiable, Codable, Equatable {
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        if(lhs.title != nil){
            lhs.title == rhs.title
        }else{
            lhs.icon == rhs.icon
        }
    }
    
    var id: UUID = UUID()
    var title: String?
    var color: Color
    var icon: Icon?
    
    func display()->some View {
        AnyView(
            Group{
                if icon != nil {
                    self.icon!.display()
                        .frame(maxWidth: 15,maxHeight: 15)
                }
                else {
                    Text(self.title!)
                }
            }
            .lineTag(color: self.color)
            .frame(height: 20)
        )
    }
    
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
}

class TagModel: ObservableObject {
    @Published var tag:Tag
    
    init(tag: Tag) {
        self.tag = tag
    }
    
    func setColor(color:Color){
        tag.color = color
    }
    
    func setTitle(title:String){
        tag.title = title
    }
    
    func setIcon(icon: Icon){
        tag.icon = icon
    }
}


class TagManageModel:ObservableObject {
    @Published var tags:[Tag]
    
    init(tags: [Tag]) {
        self.tags = tags
    }
    
    func add (tags:[Tag]){
        self.tags = tags
    }
    
    func add (tag:Tag){
        self.tags.append(tag)
    }
    
    func remove(at:Int){
        tags.remove(at: at)
    }
    
    func removeAll(){
        tags.removeAll()
    }
}
