# TUMex App To-Do List

## Module 1: Authentication ✅ COMPLETED

### Phase 1: Project Setup ✅
- [x] Initialize Flutter project.
- [x] Add Firebase Core, Firebase Auth, and Provider/Riverpod dependencies to `pubspec.yaml`.
- [x] Set up Firebase configuration files for Android and iOS.
- [x] Configure Firebase project (t-u-mex-x693t8) and generate firebase_options.dart
- [x] Set up Android Gradle configuration for Firebase
- [x] Configure app for mobile-only with portrait orientation lock

### Phase 2: UI Development ✅
- [x] Create Login Screen UI (`lib/features/auth/screens/login_screen.dart`).
- [x] Create Sign-Up Screen UI (`lib/features/auth/screens/signup_screen.dart`).
- [x] Create Forgot Password Screen UI (`lib/features/auth/screens/forgot_password_screen.dart`).
- [x] Create a shared `widgets` folder for common UI elements (e.g., custom buttons, text fields).

### Phase 3: Firebase Logic & State Management ✅
- [x] Create an `AuthenticationService` class (`lib/features/auth/services/auth_service.dart`) to handle all Firebase Auth interactions (login, signup, sign out, password reset).
- [x] Implement email and password sign-up logic.
- [x] Implement email and password login logic.
- [x] Implement sign-out logic.
- [x] Implement password recovery logic.
- [x] Set up a root widget (`AuthGate` or similar) to listen to authentication state changes and direct users to the appropriate screen (Login vs. Home).

## Module 2: User Profile & Settings 🔄 IN PROGRESS

### Phase 1: Firestore Integration for User Data
- [ ] Create a `UserModel` class (`lib/features/profile/models/user_model.dart`) to represent the user data structure from Firestore.
- [ ] Create a `ProfileService` (`lib/features/profile/services/profile_service.dart`) to handle all Firestore operations for user documents.
- [ ] Implement a function to generate the custom user ID (`use` + `YY` + `######`).
- [ ] Modify `AuthenticationService` to create a user document in Firestore upon successful registration, including all required fields (`uid`, `email`, `access_level`, `created_time`, custom ID, etc.).
- [ ] Update `ProfileScreen` to fetch user data from Firestore instead of only Firebase Auth.
- [ ] Implement the "Save Profile" logic to update the user document in Firestore, making sure to update `edited_time`.

### Phase 2: Profile Picture Management
- [ ] Add `image_picker` dependency to `pubspec.yaml`.
- [ ] Implement logic to pick an image from the device's gallery.
- [ ] Create a function in `ProfileService` to upload the selected image to Firebase Storage under a path like `users/{uid}/profile_image.jpg`.
- [ ] After uploading, get the download URL and update both the `photo_url` in the user's Firestore document and the user's profile in Firebase Auth.

### Phase 3: UI and Final Touches
- [ ] Ensure `ProfileScreen` displays all data from the Firestore document correctly (phone number, last name, etc.).
- [ ] Ensure the UI correctly handles loading states and errors during data fetching and saving.
- [ ] Create the settings screen for app preferences.

## Module 3: Core App Features

### Phase 1: Navigation & Structure
- [ ] Implement bottom navigation bar
- [ ] Create main app scaffold with proper navigation
- [ ] Set up route management
- [ ] Add proper app icons and branding

### Phase 2: Home Screen Enhancement
- [x] Design and implement main dashboard
- [x] Add quick action buttons
- [ ] Implement notifications system
- [ ] Create user activity feed

## Module 4: Homepage Development

### Phase 1: Welcome Section
- [ ] Create a `Row` layout for the welcome section.
- [ ] Add `SafeArea` to avoid system UI overlap.
- [ ] Add the TUMex logo to the left.
- [ ] Add a "Bienvenido Dr. [last_name]" text widget.
- [ ] Fetch the user's last name and display it.

### Phase 2: Services Section
- [ ] Create the main container for the services.
- [ ] Create the large "Paquetes para Cirugías" card.
    - [ ] Add the background image.
    - [ ] Add the text overlay.
    - [ ] Implement navigation to the surgery packages flow.
- [ ] Create the combined "Renta de equipo y Venta de insumos" card.
    - [ ] Add the background image.
    - [ ] Add the text overlay.
    - [ ] Implement navigation.

### Phase 3: Open Orders Section
- [ ] Create a horizontal scroll view for open orders.
- [ ] For each open order card:
    - [ ] Display Order Number, Status, and Arrival Time.
    - [ ] Add the Lottie animation for the package.
    - [ ] Add a "Ver Orden" button.
    - [ ] Implement navigation to the order details screen.

### Phase 4: Navigation Bar
- [ ] Implement the bottom navigation bar.
- [ ] Create icons for Home, Notifications, Order History, and User Profile.
- [ ] Set up routing for each navigation item.

## Current Status
✅ **Authentication Module Complete**: All login, signup, and password recovery features are working
🔄 **Profile Module In Progress**: Initial UI for the profile screen is created
🔄 **Next Step**: Integrate Firestore for complete user data management as per the new plan
