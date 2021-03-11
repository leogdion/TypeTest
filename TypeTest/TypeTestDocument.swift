//
//  TypeTestDocument.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct AppIcon {
  
}

struct ImageSet {
  
}

struct AnyResource : Codable, Identifiable {
  var name : String
  var id : UUID = .init()
}

struct Project : Codable {
  var resouces : [AnyResource]
}

struct TypeTestDocument: FileDocument {
    var project: Project

    init(project: Project? = nil) {
      self.project = project ?? Project(resouces: .init())
    }

    static var readableContentTypes: [UTType] { [.exampleText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
      self.project = try JSONDecoder().decode(Project.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
      
        let data = try JSONEncoder().encode(project)
        return .init(regularFileWithContents: data)
    }
}
