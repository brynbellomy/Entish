//
//  ExistentialSystem.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftDataStructures
import LlamaKit
import Funky
import SwiftConfig


/**
    Manages entities that have existential traits (name, HP).
 */
public class ExistentialSystem: ISystem
{
    /** The unique system ID of this system. */
    public let systemID: Systems = Systems.Existential

    private var entityController: EntityController?
    private var entities = List<EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        entityController = controller
    }


    public func willMoveFromController() {
        entityController = nil
    }


    //
    // MARK: - Public API
    //

    public func createComponentForEntity(entity:Entity, config:Config) -> Result<IComponent>
    {
        return ExistentialComponent.build(config:config)
                                   .map { $0 as IComponent }
    }


    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let existentialComponent:  ExistentialComponent?   = getTypedComponent(components, .Existential)

        if let existential = existentialComponent
        {
            entities.append <| EntityView(entityID:entity.uuid, existential:existential)
            return success()
        }
        else { return failure("ExistentialSystem could not get ExistentialComponent for entity (entityID: \(entity.uuid))") }
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            let removed = entities.removeAtIndex(index)
            return removed.existentialComponent
        }
        return nil
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            return entities[index].existentialComponent
        }
        return nil
    }



    /** Private helper struct to keep references to other components containing data used by this system. */
    private struct EntityView
    {
        let entityID:          Entity.EntityID
        var existentialComponent: ExistentialComponent

        init(entityID eid:Entity.EntityID, existential e:ExistentialComponent) {
            entityID = eid
            existentialComponent = e
        }
    }
}



