//
//  ViewController.swift
//  TransformationsUI-Premium-Demo
//
//  Created by Ruben Nine on 29/06/2020.
//

import UIKit
import TransformationsUI
import Filestack
import FilestackSDK

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var editedImageView: UIImageView!

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "picture")
    }

    // MARK: - Actions

    @IBAction func presentTransformationsUI(_ sender: AnyObject) {
        guard let image = imageView.image else { return }

        let modules = Modules()

        modules.transform.cropCommands.append(
            Modules.Transform.Commands.Crop(type: .rect, aspectRatio: .original)
        )

        modules.transform.cropCommands.append(
            Modules.Transform.Commands.Crop(type: .rect, aspectRatio: .custom(CGSize(width: 16, height: 9)))
        )

        modules.text.availableFontFamilies.append(contentsOf: ["Optima Regular", "Symbol", "Tahoma"])

        modules.stickers.stickers = [
            "Elegant 1": (01...18).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            "Elegant 2": (19...36).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            "Elegant 3": (37...54).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            "Elegant 4": (55...72).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            "Elegant 5": (71...90).compactMap { UIImage(named: "stickers-elegant-\($0)") },
        ]

        do {
            let fsConfig = Filestack.Config.builder
                .with(callbackURLScheme: "transformationsuidemo")
                .with(imageURLExportPreset: .current)
                .with(maximumSelectionLimit: 1)
                .with(documentPickerAllowedUTIs: ["public.image"])
                .with(cloudSourceAllowedUTIs: ["public.image"])
                .build()

            let policy = Policy(expiry: .distantFuture,
                                call: [.pick, .read, .stat, .write, .writeURL, .store, .convert, .remove, .exif])

            let security = try FilestackSDK.Security(policy: policy, appSecret: "YOUR-APP-SECRET")
            let fsClient = Filestack.Client(apiKey: "YOUR-API-KEY", security: security, config: fsConfig)
            let config = try Config(modules: modules, fsClient: fsClient)

            let transformationsUI = TransformationsUI(with: config)

            // Set TransformationsUI delegate.
            transformationsUI.delegate = self

            // Present TransformationsUI editor.
            if let editorVC = transformationsUI.editor(with: image) {
                editorVC.modalPresentationStyle = .fullScreen
                present(editorVC, animated: true)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension ViewController: TransformationsUIDelegate {
    /// Called when the TransformationsUI editor is dismissed.
    func editorDismissed(with image: UIImage?) {
        editedImageView.image = image ?? UIImage(named: "placeholder")
    }
}
