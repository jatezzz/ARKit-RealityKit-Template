//
//  AppState.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation

enum AppState: Equatable {
    case zoom
    case gesture
    case grab
    case pointer
    case measure

    var title: String {
        switch self {
        case .zoom:
            return "Manipulate the object with the buttons"
        case .grab:
            return "Tap the screen to save and restore object's position"
        case .pointer:
            return "Tap the screen to add circles"
        case .measure:
            return "Tap two points to see the distance"
        default:
            return "Manipulate the object thought gestures"
        }
    }

    var strategy: Strategy {
        switch self {
        case .zoom:
            return ZoomStrategy()
        case .grab:
            return GrabStrategy()
        case .pointer:
            return PointerStrategy()
        case .measure:
            return MeasureStrategy()
        default:
            return GestureStrategy()
        }
    }
}
