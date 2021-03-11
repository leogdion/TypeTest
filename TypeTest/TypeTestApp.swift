//
//  TypeTestApp.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

@main
struct TypeTestApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TypeTestDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
