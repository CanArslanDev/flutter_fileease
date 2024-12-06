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

## Tasks
 - Try changing the `void` return types to `factory` when you remove the `prefer_constructors_over_static_methods` linter and encounter errors.
 - Look into the Logger package, if usable in the app, loan code related to `debugPrint` will be replaced with the Logger package.
 - User cannot exit the connection while transferring files.
 - Check if the user has enough storage space on both the phone and the database before adding files (during the transfer).
 - Check if the lastConnections of the user are cleared after file transfer (it should not change).
 - When the QR code page is opened, a connection request snackbar should not appear from the top (from inappnotifications).
 - Connection requests cannot be accepted after 5 minutes, and cannot be accepted if the user has closed the app.
   This will be handled using timestamps, and by using timestamps, when multiple requests from the same person come, the deletion of requests will be done according to the timestamp, preventing multiple requests from being deleted simultaneously.
 - When there is a large accumulation of data, such as last connections requests, the data transfer may take a long time. If the user is connected at that moment, it can affect the connection speed. A system that pauses the code while the user is connected can be implemented to prevent this.
 - A `constants.dart` file will be created, and folders such as `cloud storage files` or `profilePhotos` will be added.
 - The minimum SDK version will be set to 20 (in `build.gradle`).
 - The following entries will be added to `info.plist` [here](https://pub.dev/packages/qr_code_scanner).
 - The app will only open in portrait mode.
 - In theme mode, the `SchedulerBinding.instance.platformDispatcher.platformBrightness` will only be refreshed when the app is opened, meaning if the user minimizes the app and changes the phone theme, the theme is not updated. This will be fixed.

## Connection conditions (the remaining ones can be optional for future implementation)
 - ~~If either party exits the connection~~
 - If either party’s app is closed (this can be considered)
 - ~~If either party cancels~~
 - If any error occurs
 - If a file transfer request comes from a different user while sending a file, the user will either not be able to accept it, or a message will ask if they want to accept, and if they say yes, the file transfer will be canceled, and the new connection will be made.
 - If two requests come during a file transfer, one will be accepted, and the file transfer will start. If the other request is accepted after the first, the new connection will not be made. This applies to both the sender and the receiver.

## Future Tasks
 - The `toMap` and `fromMap` functions for the user model will be moved to the user model.
 - The Firebase functionality in the user bloc will be moved to a separate file.
 - A model will be created for `connectionRequest`, `connectedUser`, and `previousConnectionRequest` in the user model, and they will be renamed to `connectionRequests` and `previousConnectionRequests`. After the model is created, the `acceptRequest` and `acceptRequestQR` functions in the user bloc will be modified to use this model.
 - We will add an update notification system.
 - Google Analytics will be added.
 - A bloc will be created for the QR scanner page.
 - It seems that when data comes in the user list, the entire model is set from the beginning; this will be changed to only set the data that changed. After that, it will be checked if the `animatedText` created for the id can be implemented as a stateless widget on the homepage.
 - The connection request lists will be stored on the phone and cached to avoid reloading.
 - The list of user connections in the user bloc is constantly updated with emits. These values are only displayed on the receive page, so they will be updated with emits only when the receive page is opened. If possible, it will be done using `ckey` in the navigation service to make it more efficient.
 - Shimmer effects can be added for connection requests, as the loading data is coming from the model.
 - When a user exits the connection, an alert dialog can be shown to notify the other user that the connection has been exited.
 - Comparisons like:
   ```dart
   (item) =>
       item.path == file.path &&
       item.name == file.name &&
       item.fileCreatedTimestamp == file.fileCreatedTimestamp