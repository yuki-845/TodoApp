//
//  CharcterSelectView.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//

import SwiftUI

struct CharacterSelectView: View {
    @AppStorage("CharacterSelect") var CharacterSelect: String = "HiragiMikuro"

    @State var isView = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    Image("\(CharacterSelect)Back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 2.66) // ZStackのサイズ調整
                    .position(x: geometry.size.width * 0.61,y: geometry.size.height * 0.25)
                if(CharacterSelect == "HiragiMikuro") {
                    
                        HiragiMikuroView()
                            .shadow(color: Color("\(CharacterSelect)Color"), radius: 0, x: -7, y: 0)
                            .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                    
                    
                }else {
                    
                    
                }
            }
            
            Button {
                isView = true
            }label: {
                ZStack {
                    Image("\(CharacterSelect)IconBack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: -7, y: 7)
                    Image("\(CharacterSelect)Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
            }
            
            .frame(width: geometry.size.width / 2)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            
            
            
        }
    }
}

