//
//  ImageSetView.swift
//  TypeTest
//
//  Created by Leo Dion on 3/11/21.
//

import SwiftUI

struct ImageSetView: View {
  @Binding var imageSet : ImageSet
    var body: some View {
      Stepper("Value", value: self.$imageSet.value)
    }
}

struct ImageSetView_Previews: PreviewProvider {
    static var previews: some View {
      ImageSetView(imageSet: .constant(ImageSet(value: 15)))
    }
}
