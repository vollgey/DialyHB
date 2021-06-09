//
// Created by BadApple on 2019-07-29.
// Copyright (c) 2019 Studio9. All rights reserved.
//

final class Flux {

    let settingsAction: SettingsAction
    let settingsStore: SettingsStore
    let babyAction: BabyAction
    let babyStore: BabyStore
    let noteAction: NoteAction
    let noteStore: NoteStore
    let mainAction: MainAction
    let mainStore: MainStore

    init() {
        let settingsDispatcher = SettingsDispatcher()
        let babyDispatcher = BabyDispatcher()
        let noteDispatcher = NoteDispatcher()
        let mainDispatcher = MainDispatcher()

        settingsAction = SettingsAction(dispatcher: settingsDispatcher)
        settingsStore = SettingsStore(dispatcher: settingsDispatcher, babyDispatcher: babyDispatcher)

        babyAction = BabyAction(dispatcher: babyDispatcher)
        babyStore = BabyStore(dispatcher: babyDispatcher)

        noteAction = NoteAction(dispatcher: noteDispatcher)
        noteStore = NoteStore(dispatcher: noteDispatcher)

        mainAction = MainAction(dispatcher: mainDispatcher)
        mainStore = MainStore(dispatcher: mainDispatcher)
    }
}
