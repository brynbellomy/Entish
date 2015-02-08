//
//  SystemBase.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftDataStructures
import LlamaKit
import Funky
import SwiftConfig


public class SystemBase <C: IComponent, EntityView: ISystemEntityView>
{
    public var entityController: EntityController?
    public var entities = List<EntityView>()

    public init() {
    }

    public func addEntityView(entityView:EntityView) {
        entities.append(entityView)
    }

    public func didMoveToController(controller:EntityController) {
        entityController = controller
    }


    public func willMoveFromController() {
        entityController = nil
    }

    public func removeComponentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            let removed = entities.removeAtIndex(index)
            return removed.homeComponent
        }
        return nil
    }


    public func componentForEntity(entityID: Entity.EntityID) -> IComponent?
    {
        if let index = entities.find({ $0.entityID == entityID }) {
            return entities[index].homeComponent
        }
        return nil
    }

}
