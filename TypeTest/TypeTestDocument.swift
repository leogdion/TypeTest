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

struct AppIcon : Codable {
  var name : String = ""
}

struct ImageSet : Codable {
  var value : Int = 0
}

enum Asset : Codable {
  case appIcon(AppIcon)
  case imageSet(ImageSet)
  
  enum CodingKeys : CodingKey, CaseIterable {
    
    case appIcon
    case imageSet
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    for key in CodingKeys.allCases {
      let result : Asset?
      switch key {
      case .appIcon:
        result = (try container.decodeIfPresent(AppIcon.self, forKey: .appIcon)).map(Asset.appIcon)
      case .imageSet:
        result = (try (container.decodeIfPresent(ImageSet.self, forKey: .imageSet))).map(Asset.imageSet)
      }
      if let actual = result {
        self = actual
        return
      }
    }
    throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "no valid type"))
  }
  
  func encode(to encoder: Encoder) throws {
    
  }
}

extension Asset {
  var appIcon : AppIcon! {
    set {
      if let value = newValue {
        self = .appIcon(value)
      }
    }
    get {
      if case let .appIcon(value) = self {
        return value
      } else {
        return nil
      }
    }
  }
  
  var imageSet : ImageSet! {
    set {
      if let value = newValue {
        self = .imageSet(value)
      }
    }
    get {
      if case let .imageSet(value) = self {
        return value
      } else {
        return nil
      }
    }
  }
}

struct AnyResource : Codable, Identifiable {
  var name : String
  var id : UUID = .init()
  var asset : Asset
  
  func encode(to encoder: Encoder) throws {
    
  }
  
  init(from decoder: Decoder) throws {
    
  }
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
