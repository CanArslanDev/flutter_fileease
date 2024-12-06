# FileEase - Modern File Transfer Solution

![flutter_fileease_Ps](https://github.com/user-attachments/assets/560aab3f-1261-4caf-9b6e-06ab9ecbc7b2)


FileEase is a cutting-edge file transfer application developed with modern technologies, offering multi-platform support and prioritizing user experience. Built with the Flutter framework, FileEase aims to make file transfers secure, fast, and seamless.

The application uses QR code technology to facilitate file sharing between devices. Additionally, with cloud storage integration, you can securely store your files and access them whenever you need.

## 🎯 Why FileEase?

Features that make FileEase unique:

- **Fast Transfer**: High-speed transfers through optimized protocols
- **User Friendly**: Intuitive and modern interface design
- **Platform Independent**: Seamless operation on iOS, Android, and Web platforms
- **Real-Time Monitoring**: Track transfer status instantly
- **Cloud Integration**: Secure cloud storage with Firebase infrastructure
- **Automatic Synchronization**: Seamless synchronization between devices
- **QR Code Support**: QR code technology for quick device pairing
- **Storage Management**: Detailed storage usage analysis and management

## 🌟 Features

### Core Features
- Multi-platform support (iOS, Android, Web)
- High speed with optimized protocols
- Real-time transfer tracking
- Cloud storage integration
- Automatic synchronization features
- File management system
- Detailed transfer statistics

### User Experience
- Intuitive and modern UI design
- Design compatible with all screen sizes
- Dark/Light theme support
- Quick device pairing with QR code
- Storage usage tracking
- Real-time status updates
- Customizable interface
- Smooth animations
- Responsive design

### Prerequisites
- Flutter SDK (>=3.1.5)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account
- Git


## Installation and Setup

### Prerequisites
- **Flutter SDK**: Ensure that Flutter is installed on your machine. [Download Flutter](https://flutter.dev/docs/get-started/install).
- **Firebase Account**: You need a Firebase account and a project set up to connect the app.

### 1. Clone the Repository
Clone this repository to your local machine:

```
git clone https://github.com/CanArslanDev/flutter_iot_energy.git
cd flutter_iot_energy
```

### 2. Install Dependencies
Run the following command to install the necessary Flutter packages:

```
flutter pub get
```

## 3. Firebase Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/), create a new project, and add an Android/iOS app.
2. Download the `google-services.json` file for Android and place it in `android/app`. For iOS, download `GoogleService-Info.plist` and place it in `ios/Runner`.
3. In Firebase, enable **Firestore** for data storage and **Authentication** for user management.

## 4. Configure FlutterFire

Run this command to link Firebase to your Flutter project:

```
flutterfire configure
```

## 5. CORS Configuration for Web

To enable Firebase functionality for your Flutter web app, you may need to adjust CORS (Cross-Origin Resource Sharing) settings to avoid issues with requests from different origins.

Follow these steps to configure Firebase CORS settings for your Flutter web project:

1. **Go to the `flutterin\cache` directory**  
   Navigate to the `flutterin\cache` folder in your project. Inside this folder, you’ll need to locate and delete a file named `flutter_tools.stamp`.

2. **Edit the Chrome configuration for web**  
   Next, go to `flutter\packageslutter_tools\lib\src\web` and open the file `chrome.dart`.

3. **Locate the Chrome flags**  
   In the `chrome.dart` file, search for the line that includes the Chrome flags `--disable-extensions`. This line specifies Chrome's behavior during Flutter web development.

4. **Add the necessary CORS flag**  
   To enable CORS support, add the flag `--disable-web-security` in the same line. This flag disables web security features, such as CORS checks, which are necessary when interacting with Firebase services from your Flutter web app.

   The updated line will look like this:
   ```dart
   --disable-extensions --disable-web-security
   ```

### 5. Run the App
Now, start the app on an emulator or device:

```
flutter run
```

Your app should now be set up and connected to Firebase!
