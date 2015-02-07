//
//  NodeComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 2.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import LlamaKit
import SwiftConfig


public final class NodeComponent: IComponent
{
    public class func build(#config:Config) -> Result<NodeComponent> {
        let id = Entity.newID()
        return success(NodeComponent(entityID: id))
    }

    public let systemID = Systems.Node

    public var entityID: Entity.EntityID
    public var node = SKNode()
    public var shouldUpdatePositionComponent = true

    public init(entityID eid:Entity.EntityID) {
        entityID = eid
    }
}

