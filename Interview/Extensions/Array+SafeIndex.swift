//
//  StackableViewController.swift
//  Interview
//
//  Created by ilker sevim on 2.02.2022.
//

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
