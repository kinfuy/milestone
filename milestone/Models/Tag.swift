
import SwiftUI
import CoreData





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
    var create:Date
    var update:Date
    
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
    
    func into(context:NSManagedObjectContext)->TagEntity {
        let tag =  TagEntity(context: context)
        tag.id = self.id
        tag.color = self.color.toHex
        if let title = self.title {
            tag.title = title
        }
        if let icon = self.icon {
            tag.icon = icon.rawvalue
        }
        tag.create = self.create
        tag.update = self.update
        return tag
    }
    
    static func from(tag: TagEntity)-> Tag {
        var t = Tag(id:tag.id!, title:tag.title, color: Color(hex: tag.color!),create: tag.create!,update: tag.update!)
        if let icon = tag.icon {
            t.icon = Icon(emoji: icon)
        }
        return t
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
