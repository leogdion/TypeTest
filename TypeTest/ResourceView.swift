//
//  ResourceView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct ResourceView: View {
  @Binding var resource : AnyResource
    var body: some View {
      Text(resource.name)
    }
}

struct ResourceView_Previews: PreviewProvider {
    static var previews: some View {
      ResourceView(resource:
                    .constant(
                    AnyResource(name: "test")))
    }
}
