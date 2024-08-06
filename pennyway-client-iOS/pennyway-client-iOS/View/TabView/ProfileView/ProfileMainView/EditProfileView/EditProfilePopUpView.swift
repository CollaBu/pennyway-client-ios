import AVFoundation
import Photos
import SwiftUI

struct EditProfilePopUpView: View {
    @Binding var isPresented: Bool
    @Binding var showPopUpView: Bool
    @Binding var isHiddenTabBar: Bool
    @Binding var image: Image?

    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary

    let options = ["앨범에서 사진 선택", "사진 촬영", "삭제"]

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            handleOption(option)
                        }) {
                            Text(option)
                                .font(.H4MediumFont())
                                .platformTextColor(color: Color("Gray05"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12 * DynamicSizeFactor.factor())
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())

                        if option != options.last {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .background(Color("Gray01"))
                        }
                    }
                }
                .background(Color("White01"))
                .cornerRadius(7)
                .shadow(color: .black.opacity(0.06), radius: 7.29745, x: 0, y: 0)

                Button(action: {
                    isPresented = false
                    showPopUpView = false
                    isHiddenTabBar = false
                }) {
                    Text("취소")
                        .platformTextColor(color: Color("White01"))
                        .font(.H4MediumFont())
                        .frame(maxWidth: .infinity)
                        .frame(height: 46 * DynamicSizeFactor.factor())
                        .background(Color("Gray05"))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 34)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showPopUpView = false
            loadImage()

        }) {
            return ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            isHiddenTabBar = true
        }
    }

    func loadImage() {
        guard let selectedImage = selectedUIImage else {
            return
        }
        image = Image(uiImage: selectedImage)
    }

    private func handleOption(_ option: String) {
        switch option {
        case "앨범에서 사진 선택":
            checkPhotoLibraryPermission()
        case "사진 촬영":
            showPopUpView = false
            checkCameraPermission()
        case "삭제":
            image = nil
            selectedUIImage = nil
        default:
            break
        }
    }

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        handlePhotoLibraryStatus(status)
    }

    private func handlePhotoLibraryStatus(_ status: PHAuthorizationStatus) {
        Log.debug("status: \(status)")
        switch status {
        case .authorized:
            sourceType = .photoLibrary
            showImagePicker = true

//            showPopUpView = false
            Log.debug("?:\(showImagePicker)")
        case .limited:
            showImagePicker = true
//            showPopUpView = false
        case .denied, .restricted:

            showAlertAuth(type: "앨범")
        case .notDetermined:
            requestPhotoLibraryPermission()
        @unknown default:
            break
        }
    }

    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.handlePhotoLibraryStatus(status)
            }
        }
    }

    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            sourceType = .camera
            showImagePicker = true
            showPopUpView = false
        case .denied, .restricted:
            showAlertAuth(type: "카메라")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.sourceType = .camera
                        self.showImagePicker = true
                        self.showPopUpView = false
                    }
                }
            }
        @unknown default:
            break
        }
    }

    private func showAlertAuth(type: String) {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "이 앱"
        let alertVC = UIAlertController(
            title: "설정",
            message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        UIApplication.shared.windows.first!.rootViewController!.present(alertVC, animated: true, completion: nil)
    }
}
