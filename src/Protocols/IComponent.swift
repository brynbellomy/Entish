//
//  Component.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftConfig


public protocol IComponent //: IConfigBuildable
{
    var systemID: Systems         { get }
    var entityID: Entity.EntityID { get }
}

