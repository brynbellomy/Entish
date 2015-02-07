//
//  InputComponent.swift
//  GameObjects
//
//  Created by bryn austin bellomy on 2014 Dec 16.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky
import SwiftDataStructures
import SwiftLogger


public protocol IInputHandler: class
{
    var description: String { get }

    func keyDown(theEvent:NSEvent) -> Bool
    func keyUp(theEvent:NSEvent) -> Bool

    func mouseUp(theEvent:NSEvent) -> Bool
    func mouseDown(theEvent:NSEvent) -> Bool
    func mouseDragged(theEvent:NSEvent) -> Bool
    func mouseMoved(theEvent:NSEvent) -> Bool
}


public class InputComponent: NSResponder
{
    public typealias UnderlyingCollection = Stack<IInputHandler>
    public typealias Index = UnderlyingCollection.Index

    public var debugLogKeyCodes = false

    public private(set) var inputHandlers = UnderlyingCollection()

    public func pushInputHandler(handler:IInputHandler) {
        inputHandlers.push(handler)
    }

    public func popInputHandler() -> IInputHandler? {
        return inputHandlers.pop()
    }

    public func find(predicate: (IInputHandler) -> Bool) -> Index? {
        return inputHandlers.find { predicate($0) }
    }

    public func removeInputHandler(handler:IInputHandler) {
        if let index = find({ $0 === handler }) {
            removeAtIndex(index)
        }
    }

    public func removeAtIndex(index:Index) -> IInputHandler {
        return inputHandlers.removeAtIndex(index)
    }

    //
    // MARK: - Input callbacks
    //

    private func descendStackWithClosure(closure:(IInputHandler) -> Bool)
    {
        for handler in inputHandlers
        {
            let didHandle = closure(handler)
            if didHandle {
                return
            }
        }
    }

    public override func keyDown(theEvent:NSEvent)
    {
        if debugLogKeyCodes {
            lllog(.Debug, "keyDown(): keyCode = \(theEvent.keyCode)")
        }
        descendStackWithClosure { $0.keyDown(theEvent) }
    }

    public override func keyUp(theEvent:NSEvent)        { descendStackWithClosure { $0.keyUp(theEvent) } }
    public override func mouseUp(theEvent:NSEvent)      { descendStackWithClosure { $0.mouseUp(theEvent) } }
    public override func mouseDown(theEvent:NSEvent)    { descendStackWithClosure { $0.mouseDown(theEvent) } }
    public override func mouseDragged(theEvent:NSEvent) { descendStackWithClosure { $0.mouseDragged(theEvent) } }
    public override func mouseMoved(theEvent:NSEvent)   { descendStackWithClosure { $0.mouseMoved(theEvent) } }
}












