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

enum Asset {
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
  internal init(name: String, asset: Asset, id: UUID = .init()) {
    self.name = name
    self.id = id
    self.asset = asset
  }
  
  var name : String
  var id : UUID = .init()
  var asset : Asset
  
  
  enum CodingKeys : CodingKey, CaseIterable {
    case name
    case appIcon
    case imageSet
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    switch self.asset {
    case .appIcon(let appIcon):
      try container.encode(appIcon, forKey: .appIcon)
    case .imageSet(let imageSet):
      try container.encode(imageSet, forKey: .imageSet)
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    let types = Set(container.allKeys).intersection([.appIcon, .imageSet])
    
    guard let type = types.first, types.count == 1 else {
      throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "Mismatched types: \(types)"))
    }
    
    switch type {
    case .appIcon:
      self.asset = .appIcon(try container.decode(AppIcon.self, forKey: type))
    case .imageSet:
      self.asset = .imageSet(try container.decode(ImageSet.self, forKey: type))
    default:
      throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "Mismatched type: \(type)"))      
    }
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
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(project)
        return .init(regularFileWithContents: data)
    }
}
