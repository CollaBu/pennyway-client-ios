import SwiftUI

// MARK: - ImagePicker

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var mode

    @Binding var image: UIImage?
    @Binding var isActive: Bool
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}
}

// MARK: ImagePicker.Coordinator

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            parent.image = image
            parent.mode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.isActive = false
            parent.mode.wrappedValue.dismiss()
        }
    }
}
