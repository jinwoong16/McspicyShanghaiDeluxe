//
//  ModelStore.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/4/24.
//

import Foundation

protocol ModelStore<Model> {
    associatedtype Model: Identifiable
    
    func fetch(by id: Model.ID) -> Model?
}

final class AnyModelStore<Model: Identifiable>: ModelStore {
    private let models: [Model.ID: Model]
    
    init(models: [Model]) {
        self.models = models.groupingByID()
    }
    
    func fetch(by id: Model.ID) -> Model? {
        models[id]
    }
}
