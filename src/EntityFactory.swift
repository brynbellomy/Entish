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


/**
    Factory class that produces `Entity` objects and the `IComponent` instances with which they are associated.

    @@TODO: describe configuration
 */
public class EntityFactory
{
    /** A dictionary of `Config`s used to instantiate `Entity` objects.  The `Config`s are keyed by template name. */
    public var entityTemplates  = [String: Config]()

    /**
        An object implementing `IComponentFactory` that is used by the `EntityFactory` to create each
        `Entity`'s components.  By default, `EntityFactory` instantiates a `ComponentFactory`, but this
        property can be set to a custom `IComponentFactory` instance at any time.
    */
    public var createComponentFromConfig: (Config -> Result<IComponent>)?
//    public var componentFactory: IComponentFactory = ComponentFactory()


    /** The designated initializer. */
    public init() {
    }


    /**
        Call `configure()` with a `Config` containing your entity templates.  See the main `EntityFactory`
        description for more information on configuration.
    */
    public func configure(config: Config)
    {
        entityTemplates = (config.get("entity templates") as [Config]?)
                                ?? []
                                |> map‡ (zipMapLeft { $0.get("name") as String? })  // [(String?, Config)]
                                |> mapFilter (rejectEitherNil)                      // [(String, Config)]
                                |> mapToDictionary(id)                              // [String: Config]
    }


    /**
        Attempts to create an `Entity` and its associated `IComponent`s from a template with the
        provided `templateName` (which must be available in the `Config` that was passed to `configure()`).
    
        :param: templateName The name of the template with which to instantiate the `Entity`.
        :returns: A `Result` containing a tuple.  The tuple contains the `Entity` and an array of `IComponent`s.
     */
    public func createEntityFromTemplate(templateName:String) -> Result<(Entity, [IComponent])>
    {
        if createComponentFromConfig == nil {
            return failure("Cannot create components for entities because createComponentFromConfig is nil.")
        }

        if let template = entityTemplates[templateName]
        {
            return (template.get("components") as [Config]? ?± failure("Could not get value of key 'components' for template '\(templateName)' as a [Config]."))
                            .flatMap { configs in
                                let components = configs |> map‡ { self.createComponentFromConfig!($0) } //componentFactory.createComponent($0) }
                                                         |> coalesce

                                return components.map { components in
                                    let componentBitmask = components |> reducer(Bitmask<Systems>.allZeros) { $0 | $1.systemID }
                                    let entity = Entity(uuid:Entity.newID(), componentBitmask:componentBitmask)
                                    return (entity, components)
                                }
                            }
        }
        else { return failure("Could not find entity template named '\(templateName)'.") }
    }
}



