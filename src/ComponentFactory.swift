//
//  ComponentFactory.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit
import SwiftBitmask
import SwiftDataStructures
import Funky
import SwiftConfig


/**
    If your use case requires a custom factory class for instantiating `Entity` components, that
    factory class must implement `IComponentFactory`.  Create an instance of your custom class
    and assign it to the `componentFactory` property on your `EntityController`.
*/
public protocol IComponentFactory
{
    mutating func createComponent(config:Config) -> Result<IComponent>
}

public class ComponentFactory: IComponentFactory
{
    public init() {}

    public func createComponent(config:Config) -> Result<IComponent> {
        if let system: Systems = config.get("system")
        {
            switch system
            {
                case .Node:         return NodeComponent.build(config: config).map { $0 as IComponent }
//                case .Physics:      return PhysicsComponent.build(config: config).map { $0 as IComponent }
                case .Sprite:       return SpriteComponent.build(config: config).map { $0 as IComponent }
                case .Position:     return PositionComponent.build(config: config).map { $0 as IComponent }
                case .Existential:     return ExistentialComponent.build(config: config).map { $0 as IComponent }
//                case .Animation:    return AnimationComponent.build(config: config).map { $0 as IComponent }
    //            case .Steering:
                default:
                    return failure("Unknown system type '\(system)'")
            }
        }
        else { return failure("Could not find key 'system' in component Config.") }
    }
}



