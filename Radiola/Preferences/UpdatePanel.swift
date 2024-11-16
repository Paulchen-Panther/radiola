//
//  UpdatePanel.swift
//  Radiola
//
//  Created by Alex Sokolov on 23.07.2022.
//

import Cocoa

class UpdatePanel: NSViewController {
    @IBOutlet var checkNowButton: NSButton!
    @IBOutlet var automaticallyChecksForUpdates: NSButton!

    /* ****************************************
     *
     * ****************************************/
    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("Updates", tableName: "Settings", comment: "Settings tab title")
    }

    /* ****************************************
     *
     * ****************************************/
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /* ****************************************
     *
     * ****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        checkNowButton.target = updater
        checkNowButton.action = #selector(Updater.checkForUpdates)

        automaticallyChecksForUpdates.state = updater.automaticallyChecksForUpdates ? .on : .off
    }

    /* ****************************************
     *
     * ****************************************/
    @IBAction func autoUpdateClicked(_ sender: NSButton) {
        updater.automaticallyChecksForUpdates = sender.state == .on
    }
}
