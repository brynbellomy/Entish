//
//  Entity.swift
//  Entish
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftBitmask


public struct Entity <T: IBitmaskRepresentable>
{
    public typealias EntityID = NSUUID

    public let uuid: EntityID
    public let componentBitmask: Bitmask<T>

    public init(uuid u:EntityID, componentBitmask bitmask:Bitmask<T>) {
        uuid = u
        componentBitmask = bitmask
    }

}


