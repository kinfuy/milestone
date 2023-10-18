import SwiftUI

struct TagListView: View {
    @EnvironmentObject var tagManage:TagManageModel
    
    @Binding var isEdit:Bool
    
    @State var reactHeight:CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
                
        }
        
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return  ZStack(alignment: .topLeading) {
            ForEach(Array(self.tagManage.tags.enumerated()), id: \.element.id) { index,platform in
                self.item(for: platform,index:index)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.tagManage.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.tagManage.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
               
            }
        }
    }
    
    func item(for tag: Tag,index:Int) -> some View {
        HStack{
            tag.display()
            if(self.isEdit){
                SFSymbol.close
                    .font(.caption)
                    .onTapGesture{
                        self.tagManage.remove(at: index)
                    }
            }
        }
    }
}

