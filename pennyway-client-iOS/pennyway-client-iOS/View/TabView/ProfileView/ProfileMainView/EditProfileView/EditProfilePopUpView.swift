import AVFoundation
import Photos
import SwiftUI

struct EditProfilePopUpView: View {
    @Binding var isPresented: Bool
    @Binding var showPopUpView: Bool
    @Binding var isHiddenTabBar: Bool
    @Binding var showImagePicker: Bool
    @Binding var selectedUIImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var imageUrl: String

    @StateObject var deleteProfileImageViewModel = DeleteProfileImageViewModel()
    @ObservedObject var presignedUrlViewModel: PresignedUrlViewModel

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
                        .buttonStyle(BasicButtonStyleUtil())

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
                .buttonStyle(BasicButtonStyleUtil())
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 34)
        .onAppear {
            isHiddenTabBar = true
        }
        .analyzeEvent(ProfileEvents.profileImageEditPopUp)
    }

    private func handleOption(_ option: String) {
        switch option {
        case "앨범에서 사진 선택":
            checkPhotoLibraryPermission()
        case "사진 촬영":
            checkCameraPermission()
        case "삭제":
            deleteProfileImage()
        default:
            break
        }
    }

    private func deleteProfileImage() {
        if let url = getUserData()?.profileImageUrl, !url.isEmpty {
            deleteProfileImageViewModel.deleteProfileImageApi { success in
                if success {
                    Log.debug("deleteProfileImageApi 성공")
                    selectedUIImage = nil
                    imageUrl = ""
                } else {
                    Log.debug("삭제 api 호출 실패")
                }
                isPresented = false
                showPopUpView = false
                isHiddenTabBar = false
            }
        } else {
            Log.debug("프로필 사진 비어 있음")
            isPresented = false
            showPopUpView = false
            isHiddenTabBar = false
        }
    }

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        handlePhotoLibraryStatus(status)
    }

    private func handlePhotoLibraryStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            sourceType = .photoLibrary
            showImagePicker = true
        case .denied, .restricted:
            showAlertAuth(type: "앨범")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.handlePhotoLibraryStatus(status)
                }
            }
        @unknown default:
            break
        }
    }

    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            sourceType = .camera
        case .denied, .restricted:
            showAlertAuth(type: "카메라")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.sourceType = .camera
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
