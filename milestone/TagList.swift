import SwiftUI

struct TagListView: View {
    @Binding var tags:[Tag]
    
    @Binding var isEdit:Bool
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(Array(self.tags.enumerated()), id: \.element.id) { index,platform in
                self.item(for: platform,index:index)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
    
    func item(for tag: Tag,index:Int) -> some View {
        HStack{
            Text(tag.title!)
            if(self.isEdit){
                SFSymbol.close
                    .font(.caption)
                    .onTapGesture{
                        self.tags.remove(at: index)
                    }
                
            }
        }
        .lineTag(color: tag.color,font: .system(size: 16))
    }
}

