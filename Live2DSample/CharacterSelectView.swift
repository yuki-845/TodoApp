import SwiftUI
import Live2DMetal
import Live2DMetalObjC

struct Character: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}
class CharacterManager: ObservableObject {
    @AppStorage("CharacterSelect") var characterSelect: String = "HiragiMiroku"
    
    @Published var characterList: [Character] = [
        Character(name: "HiragiMiroku", isSelected: true),
        Character(name: "Hiyori", isSelected: false)
    ]
    
    func selectCharacter(at index: Int) {
        for i in characterList.indices {
            characterList[i].isSelected = (i == index)
        }
        characterSelect = characterList[index].name
    }
}
struct CharacterSelectView: View {
    @EnvironmentObject var characterManager: CharacterManager 
    @State var isActive = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("\(characterManager.characterSelect)Back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 2.66)
                    .position(x: geometry.size.width * 0.61, y: geometry.size.height * 0.25)
                
               if characterManager.characterList[0].isSelected {
                   
            }
                
               
            }
            HiragiMirokuView()
                .shadow(color: Color("\(characterManager.characterSelect)Color"), radius: 0, x: -7, y: 0)
                .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .opacity(1)
//            HiyoriView(isActive: $isActive)
//            if characterManager.characterList[1].isSelected {
//            }

            HStack {
//                ForEach(Array(characterManager.characterList.enumerated()), id: \.offset) { index, character in
//                    Button {
//                       
//                      
//                        characterManager.selectCharacter(at: index)
//                       
//                        
//                    } label: {
//                        ZStack {
//                            Image("\(character.name)IconBack")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .offset(x: -7, y: 7)
//                            Image("\(character.name)Icon")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                        }
//                    }
//                }
//                .frame(width: geometry.size.width / 2)
//                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            }
        }
    }
}
