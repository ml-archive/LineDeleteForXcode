//
//  DeleteLineCommand.swift
//  Extension
//
//  Created by Dominik Hádl on 17/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import XcodeKit

class DeleteLineCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {

        // Cancel early
        invocation.cancellationHandler = {
            completionHandler(nil)
        }

        // Delete the line
        do {
            try deleteLinesFromCurrentBuffer(buffer: invocation.buffer)
        } catch {
            completionHandler(error)
        }

        // Finish
        completionHandler(nil)
    }

    func deleteLinesFromCurrentBuffer(buffer: XCSourceTextBuffer) throws {
        guard let selection = buffer.selections.firstObject as? XCSourceTextRange,
            selection.start.line > 0, selection.end.line < buffer.lines.count else {
                throw NSError(domain: "com.nodes.DeleteLineForXcode",
                              code: 1,
                            userInfo: [NSLocalizedDescriptionKey : "Error while getting current line."])
        }

        if selection.start.line == selection.end.line {
            buffer.lines.removeObject(at: selection.start.line)
        } else {
            let range = NSRange(location: selection.start.line,
                                length: selection.end.line - selection.start.line)
            buffer.lines.removeObjects(in: range)
        }
    }
}
