# Free Stuff App

A modern iOS SwiftUI app that enables people to GIVE and CLAIM free items locally, with minimal friction.

## Features

- **Authentication**: Firebase Authentication with Email/Google/Apple sign-in
- **Item Posting**: Post items with photos, categories, and location
- **Item Feed**: Browse available items sorted by distance
- **Claim Flow**: Claim items and start conversations with owners
- **In-App Messaging**: Real-time chat between owners and claimers
- **Profile Management**: View posted and claimed items
- **Trust & Safety**: Report items and users

## Tech Stack

- **Language**: Swift (SwiftUI)
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **Location**: CoreLocation for city detection and distance calculation
- **Architecture**: MVVM with Combine
- **UI**: Clean, modern iOS 17 design

## Setup Instructions

### 1. Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an iOS app to your project with bundle ID: `com.aerhelle.FreeStuff`
3. Download the `GoogleService-Info.plist` file
4. Replace the placeholder `GoogleService-Info.plist` in the project with your actual file

### 2. Firebase Services Setup

#### Authentication
1. Enable Email/Password authentication in Firebase Console
2. Enable Google Sign-In (optional)
3. Enable Apple Sign-In (optional)

#### Firestore Database
1. Create a Firestore database in production mode
2. Set up the following collections:
   - `users` - User profiles
   - `items` - Posted items
   - `claims` - Item claims
   - `chats` - Chat conversations
   - `messages` - Chat messages
   - `reports` - User/item reports

#### Storage
1. Enable Firebase Storage
2. Set up storage rules for image uploads

#### Cloud Messaging
1. Enable Firebase Cloud Messaging for push notifications

### 3. Xcode Project Setup

1. Open `FreeStuff.xcodeproj` in Xcode
2. Add Firebase SDK dependencies via Swift Package Manager:
   - Go to File → Add Package Dependencies
   - Add: `https://github.com/firebase/firebase-ios-sdk`
   - Select the following products:
     - FirebaseAuth
     - FirebaseFirestore
     - FirebaseStorage
     - FirebaseMessaging

### 4. Location Permissions

The app requires location permissions to:
- Auto-detect user's city
- Calculate distances to items
- Sort items by proximity

Add the following to your `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby items and auto-detect your city.</string>
```

### 5. Build and Run

1. Select your target device or simulator
2. Build and run the project (⌘+R)

## Project Structure

```
FreeStuff/
├── Models/           # Data models (User, Item, Claim, Message, Report)
├── ViewModels/       # MVVM ViewModels
├── Views/            # SwiftUI Views
│   ├── Authentication/
│   ├── Main/
│   ├── Profile/
│   ├── Chat/
│   └── Utils/
├── Services/         # Firebase and Location services
├── Utils/            # Utility functions
└── Extensions/       # Swift extensions
```

## Key Features Implementation

### Authentication
- Email/password sign-up and sign-in
- Social authentication (Google/Apple) - requires additional setup
- User profile management

### Item Management
- Post items with photos, categories, and location
- Real-time item feed with distance-based sorting
- Category filtering
- Item status management (available, claimed, given away)

### Messaging System
- Real-time chat between item owners and claimers
- Chat list with unread message indicators
- Message history persistence

### Location Services
- Automatic city detection using CoreLocation
- Distance calculation between users and items
- Location-based item sorting

## Testing

The app includes comprehensive unit tests for:
- ViewModels and business logic
- Firebase service methods
- Location service functionality

Run tests with ⌘+U in Xcode.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
