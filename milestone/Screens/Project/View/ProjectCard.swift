//
//  ProjectCard.swift
//  milestone
//
//  Created by 杨杨杨 on 2023/9/10.
//

import SwiftUI

let MMDDHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日 HH:mm"
    return formatter
}()

let YYMMDDHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

extension ProjectView {
    struct ProjectCard: View {
        var project:Project
        var body: some View {
            HStack{
                VStack{
                      Text(self.project.icon)
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                        .frame(width: 32,height: 32)
                        .padding(12)
                }
                .background(self.project.iconColor)
                .cornerRadius(16)
                .padding(.leading)
                
                HStack{
                    VStack(alignment: .leading){
                        Text(self.project.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, -4)
                        HStack{
                            ForEach(self.project.tags){ tag in
                                tag.display()
                            }
                        }
                        .padding(.vertical,1)
                        Text(YYMMDDHHMM.string(from: self.project.update))
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

