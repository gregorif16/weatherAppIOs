//
//  AvatarImageModifier.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import SwiftUI

struct AvatarImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .background(.gray.opacity(0.32))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
