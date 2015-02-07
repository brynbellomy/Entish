//
//  EventHandler.swift
//  GameObjects
//
//  Created by bryn austin bellomy on 2014 Sep 28.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky
import Signals
import BrynSwift

//
// USAGE:
// ======
//        var eventHandler = EventHandler().when { node_hero.position.distanceTo(seekPoint) <= 10 }
//                                         .then { node_hero.seek(CGPoint(x:100, y:500), slowingRadius:100, key:"seek")
//
//        eventHandler.checkConditionInterval = 1.0
//        eventHandler.throttleInterval = 1.0
//        eventHandler.removeAfterFiring = true
//
//        eventController.addEventHandler(eventHandler)


public class EventComponent
{
    private var controller = Controller<NSUUID, EventHandler>()
    private var events = [NSUUID: EventHandler]()


    public init() {}


    public func addEventHandler(eventHandler:EventHandler)
    {
        eventHandler.manager = self
        events[eventHandler.uuid] = eventHandler
    }


    public func removeEventHandler(eventHandler:EventHandler)
    {
        if let handler = events[eventHandler.uuid]
        {
            if handler.manager === self {
                handler.manager = nil
            }
        }
        events.removeValueForKey(eventHandler.uuid)
    }


    public func update(timeSinceLastUpdate:NSTimeInterval)
    {
        for (uuid, event) in events {
            event.update(timeSinceLastUpdate)
        }
    }
}


public class EventHandler //: IComponent
{
    public typealias ConditionBlock = () -> Bool
    public typealias ActionBlock    = () -> Void

    /** How often the condition block is executed. */
    public var checkConditionInterval : NSTimeInterval = 0.5

    /** The minimum interval between executions of the action block. */
    public var throttleInterval       : NSTimeInterval = 0.5

    /** If true, the handler will be removed after the first execution of the action block. */
    public var removeAfterFiring      : Bool = false

    private weak var manager : EventComponent?

    private let uuid = NSUUID()
    private var block_if : ConditionBlock?
    private var timeSinceLastFired : NSTimeInterval = 0
    private var timeSinceConditionChecked : NSTimeInterval = 0

    private var canCheckCondition : Bool { return timeSinceConditionChecked >= checkConditionInterval }
    private var canFireHandler    : Bool { return timeSinceLastFired        >= throttleInterval }

    private let onFire = Signal<Void>()


    public init()
    {
    }


    /**
        Sets the condition-checking block for the event handler.  When this block returns
        true, the action block is fired.  This method is chainable.
      */
    public func when(block:ConditionBlock) -> EventHandler
    {
        block_if = block
        return self
    }


    /**
        Sets the action block for the event handler.  The action block is executed any time
        the condition block is called and returns true.  This method is chainable.
      */
    public func then(block:ActionBlock) -> EventHandler
    {
        onFire.listen(self, block)
        return self
    }


    public func didMoveToController() {

    }


    public func willMoveFromController() {

    }


    private func update(timeSinceLastUpdate:NSTimeInterval)
    {
        timeSinceConditionChecked += timeSinceLastUpdate
        timeSinceLastFired += timeSinceLastUpdate

        if canCheckCondition
        {
            let conditionIsTrue = block_if?() ?? false
            if canFireHandler && conditionIsTrue {
                fireHandler()
            }
            timeSinceConditionChecked = 0
        }
    }


    private func fireHandler()
    {
        onFire.fire()
        timeSinceLastFired = 0

        if removeAfterFiring {
            manager?.removeEventHandler(self)
        }
    }
}



extension EventHandler: Equatable {}

public func == (lhs:EventHandler, rhs:EventHandler) -> Bool {
    return lhs.uuid.isEqual(rhs.uuid)
}


