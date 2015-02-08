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
    public let systemID: Systems = .Existential

    private var base = SystemBase<ExistentialComponent, EntityView>()


    //
    // MARK: - Lifecycle
    //

    /** The designated initializer. */
    public init() {
    }


    public func didMoveToController(controller:EntityController) {
        base.didMoveToController(controller)
    }


    public func willMoveFromController() {
        base.willMoveFromController()
    }


    //
    // MARK: - Public API
    //

    public func addEntity(entity: Entity, withComponents components:[IComponent]) -> Result<Void>
    {
        let existentialComponent:  ExistentialComponent? = getTypedComponent(components, .Existential)
        if let existentialCmpt = existentialComponent
        {
            base.addEntityView <| EntityView(entityID:entity.uuid, existential:existentialCmpt)
            return success()
        }
        else { return failure("ExistentialSystem could not get ExistentialComponent for entity (entityID: \(entity.uuid))") }
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.componentForEntity(entityID)
    }


    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent? {
        return base.removeComponentForEntity(entityID)
    }


    /** Private helper struct to keep references to other components containing data used by this system. */
    private struct EntityView: ISystemEntityView
    {
        let entityID: Entity.EntityID
        var homeComponent: IComponent { return existentialComponent }

        var existentialComponent: ExistentialComponent

        init(entityID eid:Entity.EntityID, existential e:ExistentialComponent) {
            entityID = eid
            existentialComponent = e
        }
    }
}



