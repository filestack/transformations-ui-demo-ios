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
            let premiumModules = try PremiumModules(apiKey: "YOUR-API-KEY-HERE")

            premiumModules.transform.cropCommands.append(
                PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .original)
            )

            premiumModules.transform.cropCommands.append(
                PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .custom(CGSize(width: 16, height: 9)))
            )

            premiumModules.text.availableFontFamilies.append(contentsOf: ["Optima Regular", "Symbol", "Tahoma"])

            premiumModules.sticker.stickers = [
                "Elegant 1": (01...18).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                "Elegant 2": (19...36).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                "Elegant 3": (37...54).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                "Elegant 4": (55...72).compactMap { UIImage(named: "stickers-elegant-\($0)") },
                "Elegant 5": (71...90).compactMap { UIImage(named: "stickers-elegant-\($0)") },
            ]

            config = Config(modules: premiumModules)
        } catch {
            config = Config()
        }

        let transformationsUI = TransformationsUI(with: config)

        transformationsUI.delegate = self

        if let editorVC = transformationsUI.editor(with: image) {
            editorVC.modalPresentationStyle = .fullScreen
            present(editorVC, animated: true)
        }
    }
}

extension ViewController: TransformationsUIDelegate {
    func editorDismissed(with image: UIImage?) {
        editedImageView.image = image ?? UIImage(named: "placeholder")
    }
}
