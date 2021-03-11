//
//  AppIconView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct AppIconView: View {
  @Binding var appIcon : AppIcon
    var body: some View {
      TextField.init("test", text: self.$appIcon.name)
      
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
      AppIconView(appIcon: .constant(AppIcon(name: "Hello")))
    }
}
