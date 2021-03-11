//
//  ContentView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TypeTestDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(TypeTestDocument()))
    }
}
