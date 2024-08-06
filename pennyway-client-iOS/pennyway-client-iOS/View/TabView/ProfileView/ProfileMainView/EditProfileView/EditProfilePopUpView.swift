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
    @State private var showCamera = false
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

                Spacer().frame(height: 9 * DynamicSizeFactor.factor())

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
            loadImage()
        }) {
            ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            isHiddenTabBar = true
            Log.debug("?????:\(isHiddenTabBar)")
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
            Log.debug("앨범에서 사진 선택")
        case "사진 촬영":
            showPopUpView = false
            checkCameraPermission()
            Log.debug("사진 촬영")
        case "삭제":
            Log.debug("삭제")
        default:
            Log.debug("알 수 없는 옵션")
        }
    }

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            sourceType = .photoLibrary
            showImagePicker = true
            showPopUpView = false
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        sourceType = .photoLibrary
                        showImagePicker = true
                        showPopUpView = false
                    }
                }
            }
        } else {
            // Handle permission alert
        }
    }

    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            sourceType = .camera
            showImagePicker = true
            showPopUpView = false
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        sourceType = .camera
                        showImagePicker = true
                        showPopUpView = false
                    }
                }
            }
        } else {
            // Handle permission alert
        }
    }
}
