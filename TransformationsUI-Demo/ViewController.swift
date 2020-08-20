//
//  ViewController.swift
//  TransformationsUI-Demo
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

        let modules: PremiumModules

        do {
            modules = try PremiumModules(apiKey: "YOUR-API-KEY")
        } catch {
            debugPrint("Error: \(error)")
            return
        }

        modules.transform.cropCommands.append(
            PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .original)
        )

        modules.transform.cropCommands.append(
            PremiumModules.Transform.Commands.Crop(type: .rect, aspectRatio: .custom(CGSize(width: 16, height: 9)))
        )

        let transformationsUI = TransformationsUI(with: Config(modules: modules))

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
