//
//  ProjectCard.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

extension Project {
    struct ProjectCard: View {
        var name:String
        var icon:String
        var update:Date
        var iconColor:Color
        var tags:[Tag] = []
        var body: some View {
            HStack{
                VStack{
                    Image(systemName: self.icon)
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .frame(width: 32,height: 32)
                        .padding(12)
                    
                }
                .background(self.iconColor)
                .cornerRadius(16)
                .padding(.leading)
                
                HStack{
                    VStack(alignment: .leading){
                        Text(self.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, -4)
                        HStack{
                            ForEach(self.tags){ tag in
                                VStack{
                                    if(tag.icon != nil ) {
                                        tag.icon
                                    }else {
                                        Text(tag.title!)
                                    }
                                }
                                .lineTag(color: tag.color)
                                
                            }
                        }
                        .padding(.vertical,1)
                        Text(dateFormatter.string(from: self.update))
                            .font(.caption)
                        
                    }
                    Spacer()
                }
                .padding(.leading,4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color("WriteColor"))
            .padding(.vertical, 4)
            .cornerRadius(8)
        }
    }
}

