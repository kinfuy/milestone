
import SwiftUI

enum IconType:Codable{
    case sfsymbol
    case emoji
}

struct Icon: Codable, Equatable {
    
    static func == (lhs: Icon, rhs: Icon) -> Bool {
        lhs.type == rhs.type && (lhs.emoji == rhs.emoji || lhs.sfsymbol == rhs.sfsymbol)
    }
    
    var type:IconType
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.emoji =  try container.decode(String.self, forKey: .emoji)
            self.type = .emoji
        } catch {
            
        }
        do {
            self.sfsymbol = try container.decode(SFSymbol.self, forKey: .sfsymbol)
            self.type = .sfsymbol
        } catch  {
            
        }
        self.type = .emoji
    }
    
    init(emoji: String) {
        self.type = IconType.emoji
        self.emoji = emoji
    }
    
    init(sfsymbol: SFSymbol){
        self.type = IconType.sfsymbol
        self.sfsymbol = sfsymbol
    }
    
    private var emoji:String?
    
    private var sfsymbol: SFSymbol?
    
    var rawvalue:  String  {
        print(self.emoji ?? "111")
        return self.emoji ?? ""
    }
    
    func display()-> some View{
        AnyView(
            Group{
                if(self.type == IconType.emoji){
                    Text(self.emoji!)
                }
                else {
                    self.sfsymbol!.resizable().scaledToFit()
                }
            }
        
        )
    }
    
    
    enum CodingKeys: CodingKey {
        case emoji
        case sfsymbol
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.emoji, forKey: .emoji)
        try container.encodeIfPresent(self.sfsymbol, forKey: .sfsymbol)
    }
    
    func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
}
