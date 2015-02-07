//
//  EntityFactory.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit
import Funky
import SwiftConfig
import SwiftBitmask


public class EntityFactory
{
    public var entityTemplates = [String: Config]()

    public init() {
    }

    public func configure(config: Config)
    {
        NSLog("configure 1 -> \(config.flatten())")
        entityTemplates = (config.get("entity templates") as [Config]?)
                                ?? []
                                |> map‡ (zipMapLeft { $0.get("name") as String? })  // [(String?, Config)]
                                |> mapFilter (rejectEitherNil)                      // [(String, Config)]
                                |> mapToDictionary(id)                              // [String: Config]
        NSLog("configure 2 -> \(entityTemplates)")
    }


    public func createEntityFromTemplate(templateName:String) -> Result<(Entity, [IComponent])>
    {
        if let template = entityTemplates[templateName]
        {
            return (template.get("components") as [Config]? ?± failure("Could not get value of key 'components' for template '\(templateName)' as a [Config]."))
                            .flatMap { configs in
                                let componentFactory = ComponentFactory()
                                let components = configs |> map‡ { componentFactory.createComponent($0) }
                                                         |> coalesce
                                NSLog("components = \(components)")
                                return components.map { components in
                                    let componentBitmask = components |> reducer(Bitmask<Systems>.allZeros) { $0 | $1.systemID }
                                    let entity = Entity(uuid:Entity.newID(), componentBitmask:componentBitmask)
                                    return (entity, components) //EntityResult(entity:entity, components:components)
                                }
                            }
        }
        else {
            return failure("Could not find entity template named '\(templateName)'.")
        }
    }
}


public class ComponentFactory
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
//                case .Animation:    return AnimationComponent.build(config: config).map { $0 as IComponent }
    //            case .Steering:
                default:
                    return failure("Unknown system type '\(system)'")
            }
        }
        else { return failure("Could not find key 'system' in component Config.") }
    }
}


