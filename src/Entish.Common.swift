//
//  Entish.Common.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 2.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftConfig
import SwiftBitmask
import Funky


/**
    Returns the first component found in the array of `IComponent`s that matches the
    specified system.  For convenience, the returned component is casted to the specified type.

    :param: components The array of components to search.
    :param: system The ID of the system that this component is associated with.
    :returns: The component, casted to the specified type, or `nil` if the component was not found or was the wrong type.
*/
public func getTypedComponent <T: IComponent> (components:[IComponent], system:Systems) -> T?
{
    if let componentIdx = findWhere(components, { $0.systemID == system })
    {
        if let component = components[componentIdx] as? T {
            return component
        }
    }
    return nil
}


public enum Systems: String
{
    case Node       = "node"
    case Physics    = "physics"
    case Sprite     = "sprite"
    case Position   = "position"
    case Animation  = "animation"
    case Steering   = "steering"
    case Existential = "existential"
}


extension Systems: IBitmaskRepresentable, IAutoBitmaskable
{
    public var bitmaskValue: UInt32 { return AutoBitmask.autoBitmaskValueFor(self) }
    public static var autoBitmaskValues: [Systems] { return [ .Node, .Physics, .Sprite, .Position, .Animation, .Steering, .Existential, ] }

//    public var bitmaskValue: UInt64
//    {
//        switch self {
//            case Node:         return 1 << 0
//            case Sprite:       return 1 << 1
//            case Physics:      return 1 << 2
//            case Position:     return 1 << 3
//            case Animation:    return 1 << 4
//            case Steering:     return 1 << 5
//        }
//    }

//    public init?(bitmaskValue: UInt64)
//    {
//        switch bitmaskValue {
//            case 1 << 0: self = .Node
//            case 1 << 1: self = .Sprite
//            case 1 << 2: self = .Physics
//            case 1 << 3: self = .Position
//            case 1 << 4: self = .Animation
//            case 1 << 5: self = .Steering
//            default:     return nil
//        }
//    }
}


extension Systems: IConfigRepresentable
{
    public static func fromConfigValue(configValue:String) -> Systems? {
        return Systems(rawValue: configValue)
    }

    public var configValue: String { return rawValue }
}



