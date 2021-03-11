//
//  ResourceView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct ResourceView: View {
  @Binding var resource : AnyResource
  @ViewBuilder
    var body: some View {
      switch resource.asset {
      case .appIcon(_):
         AppIconView(appIcon:
                      self.$resource.asset.appIcon)
        
        case .imageSet(_):
           ImageSetView(imageSet:
                        self.$resource.asset.imageSet)
      default:
        EmptyView()
      }
    }
}

struct ResourceView_Previews: PreviewProvider {
    static var previews: some View {
      ResourceView(resource:
                    .constant(
                      AnyResource(name: "test", asset: .appIcon(AppIcon(name: "Hello")))))
    }
}
