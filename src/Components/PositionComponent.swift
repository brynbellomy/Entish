//
//  PositionComponent.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 3.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftConfig
import LlamaKit


public final class PositionComponent: IComponent
{
    public class func build(#config:Config) -> Result<PositionComponent> {
        return success(PositionComponent(entityID: Entity.newID()))
    }

    
    public let systemID: Systems = .Position

    public var entityID: Entity.EntityID
    public var position = CGPointZero

    public init(entityID eid:Entity.EntityID) {
        entityID = eid
    }
}



