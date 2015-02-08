//
//  EntityController.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit
import SwiftBitmask
import SwiftDataStructures
import BrynSwift
import Funky
import SwiftConfig
import Signals


/**
    Manages a set of game systems that implement the `ISystem` protocol and
    the `Entity` objects that interact with those systems.
*/
public class EntityController
{
    public typealias EntityID = Entity.EntityID

    public private(set) var registeredSystems = [Systems]()
    public private(set) var entities = List<Entity>()
    public private(set) var systems  = Controller<Systems, ISystem>()

    public var entityFactory = EntityFactory()

    public struct Signals {
        public let update = Signal<NSTimeInterval>()
    }

    /** A struct containing the subscribable signals published by the controller. */
    public var signals = Signals()


    /**
        The designated initializer.
    */
    public init()
    {
        systems.childDidMoveToController    = { (var system) in system.didMoveToController(self) }
        systems.childWillMoveFromController = { (var system) in system.willMoveFromController() }
    }


    /**
        Initializes parameters from a loaded `Config` object.  You must call `configure()` before
        any attempting to build any `Entity` objects, as the configuration contains the templates
        used to instantiate your entities.

        :param: config a `Config` object containing `Entity` templates
     */
    public func configure(config:Config) {
        entityFactory.configure(config)
    }


    /**
        Creates a new `Entity` from the configuration template named by the `template` argument.
        The entity's components are all automatically instantiated and added to their respective
        systems.
        
        :param: template The name of the template from which to instantiate the new `Entity`.
        :returns: The `uuid` of the new `Entity`.
     */
    public func createEntity(#template:String) -> Result<Entity.EntityID>
    {
        return entityFactory.createEntityFromTemplate(template)
                            >>- { entity, components in
                                    self.addEntity(entity, withComponents:components)
                                        .map { entity.uuid }
                                }
    }


    /**
        Adds the given entity to the controller and passes its components to their
        respective registered systems.
     */
    public func addEntity (entity:Entity, withComponents components: [IComponent]) -> Result<Void>
    {
        entities.append(entity)

        return (components  |> map‡ { component in
                                self.systems[component.systemID]?.addEntity(entity, withComponents:components)
                                             ?? failure("Could not get system for ID '\(component.systemID)'")
                            }
                            |> coalesce).map { _ in () }

    }


    /**
        Removes the entity with the given ID from the controller and from all registered
        systems that it interacts with.
     */
    public func removeEntity(entityID:EntityID) -> Entity?
    {
        if let index = entities.find({ $0.uuid == entityID }) {
            let removed = entities.removeAtIndex(index)
            systems.eachChild { (var system) in system.removeComponentForEntity(entityID); return }
            return removed
        }
        return nil
    }


    /**
        Returns an array containing all entities that contain *all* of the component types
        specified by the `components` bitmask.
     */
    public func entitiesWithAllComponents (components: Bitmask<Systems>) -> [Entity] {
        return entities |> selectWhere { $0.componentBitmask == components }
    }


    /**
        Returns an array containing all entities that contain *any* of the component types
        specified by the `components` bitmask.
     */
    public func entitiesWithAnyComponents (components: Bitmask<Systems>) -> [Entity] {
        return entities |> selectWhere { $0.componentBitmask & components != .allZeros }
    }


    /**
        Registers the provided system with the controller.  All systems must be registered
        before any entities that use them are created.
     */
    public func registerSystem(system:ISystem) {
        systems[system.systemID] = system
    }


    /**
        Unregisters the system with the given ID, if one exists.  
    
        :returns: The unregistered system, or `nil` if none was found.
     */
    public func unregisterSystemWithID(systemID:Systems) -> ISystem? {
        return systems.remove(systemID)
    }


    /**
        Scene loop update method.  Call this from your scene's `update()` method.  It updates
        all entities and systems that are currently registered with the controller.
     */
    public func update(currentTime:NSTimeInterval)
    {
        signals.update.fire(currentTime)

//        let registeredSystems = self.registeredSystems
//        entities = entities |> mapTo { entity in
//            for option in registeredSystems
//            {
//                if entity.componentBitmask.isSet(option) {
//                    if var system = self.systems[option] {
//                        system.update(currentTime)
//                    }
//                }
//            }
//            return entity
//        }

    }
}



