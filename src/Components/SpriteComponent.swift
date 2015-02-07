//
//  SpriteComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import LlamaKit
import SwiftConfig


public final class SpriteComponent: IComponent
{
    public class func build(#config:Config) -> Result<SpriteComponent> {
        return success(SpriteComponent(entityID: Entity.newID()))
    }

    public let systemID: Systems = .Sprite
    public var entityID: Entity.EntityID

    public var spriteNode = SKSpriteNode()

    public init(entityID eid:Entity.EntityID) {
        entityID = eid
    }
}
