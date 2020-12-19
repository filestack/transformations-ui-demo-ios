//
//  ViewController.swift
//  TransformationsUI-Premium-Demo
//
//  Created by Ruben Nine on 29/06/2020.
//

import UIKit
import TransformationsUI
import TransformationsUIPremiumAddOns

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

        let config: Config

        do {
            // Try to use Premium Modules.
            // (requires a valid Filestack API key with permissions to use Transformations UI.)
            let modules = try PremiumModules(apiKey: "YOUR-API-KEY-HERE")

            // Add extra crop rect command that enforces original aspect ratio to transform module.
            modules.transform.cropCommands.append(
                PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .original)
            )

            // Add extra crop rect command that enforces 16/9 aspect ratio to transform module.
            modules.transform.cropCommands.append(
                PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .custom(CGSize(width: 16, height: 9)))
            )

            // Add extra available font families to text module.
            modules.text.availableFontFamilies.append(contentsOf: ["Optima Regular", "Symbol", "Tahoma"])

            // Add stickers in groups (sticker sets).
            modules.sticker.stickers = [
                // Sticker set 1
                "Elegant 1": (01...18).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                // Sticker set 2
                "Elegant 2": (19...36).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                // Sticker set 3
                "Elegant 3": (37...54).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                // Sticker set 4
                "Elegant 4": (55...72).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                // Sticker set 5
                "Elegant 5": (71...90).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            ]

            config = Config(modules: modules)
        } catch {
            // Fall-back to Standard Modules
            config = Config()
        }

        // Instantiate TransformationsUI using custom Config object `config`.
        let transformationsUI = TransformationsUI(with: config)

        // Set TransformationsUI delegate.
        transformationsUI.delegate = self

        // Present TransformationsUI editor.
        if let editorVC = transformationsUI.editor(with: image) {
            editorVC.modalPresentationStyle = .fullScreen
            present(editorVC, animated: true)
        }
    }
}

extension ViewController: TransformationsUIDelegate {
    /// Called when the TransformationsUI editor is dismissed.
    func editorDismissed(with image: UIImage?) {
        editedImageView.image = image ?? UIImage(named: "placeholder")
    }
}
