//
//  ContentView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TypeTestDocument

  func binding(forResource resource: AnyResource) -> Binding<AnyResource> {
    let index = self.document.project.resouces.firstIndex(where: {$0.id == resource.id})!
    
    return self.$document.project.resouces[index]
  }
    var body: some View {
      NavigationView{
        List(self.document.project.resouces) { (resource) in
          NavigationLink(
            destination: ResourceView(resource: self.binding(forResource: resource)),
            label: {
              
          Text(
            resource.name
          )
            })
        }
      
      
        Text("No Selection")
      }.toolbar(content: {
        Button(action: {
          self.document.project.resouces.append(AnyResource(name: "New"))
        }, label: {
          /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
      })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(TypeTestDocument(
          project: Project(resouces: [AnyResource(name: "test"),AnyResource(name: "test2")])
        )))
    }
}
