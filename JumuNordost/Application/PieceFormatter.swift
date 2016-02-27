//
//  PieceFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 27/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedPiece {
    let composerInfo: String
    let title: String
}

class PieceFormatter {
    static let durationFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Positional
        return formatter
    }()

    static func formattedPiece(piece: Piece) -> FormattedPiece {
        let composerInfo: String = {
            if !piece.composerBorn.isEmpty {
                return "\(piece.composerName) (\(piece.composerBorn)–\(piece.composerDied))"
            } else {
                return piece.composerName
            }
        }()

        return FormattedPiece(
            composerInfo: composerInfo,
            title: piece.title
        )
    }
}
