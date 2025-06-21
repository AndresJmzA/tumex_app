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
- [x] Implement bottom navigation bar
- [x] Create main app scaffold with proper navigation
- [ ] Set up route management
- [ ] Add proper app icons and branding

### Phase 2: Home Screen Enhancement
- [x] Design and implement main dashboard
- [x] Add quick action buttons
- [ ] Implement notifications system
- [ ] Create user activity feed

## Module 4: Homepage Development ✅ COMPLETED

### Phase 1: Welcome Section ✅
- [x] Create a `Row` layout for the welcome section.
- [x] Add `SafeArea` to avoid system UI overlap.
- [x] Add the TUMex logo to the left.
- [x] Add a "Bienvenido Dr. [last_name]" text widget.
- [x] Fetch the user's last name and display it.

### Phase 2: Services Section ✅
- [x] Create the main container for the services.
- [x] Create the large "Paquetes para Cirugías" card.
    - [x] Add the background image.
    - [x] Add the text overlay.
    - [ ] Implement navigation to the surgery packages flow.
- [x] Create the combined "Renta de equipo y Venta de insumos" card.
    - [x] Add the background image.
    - [x] Add the text overlay.
    - [ ] Implement navigation.

### Phase 3: Open Orders Section ✅
- [x] Create a PageView for open orders.
- [x] For each open order card:
    - [x] Display Order Number, Status, and Arrival Time.
    - [x] Add the Lottie animation for the package.
    - [x] Add a "Ver Orden" button.
    - [ ] Implement navigation to the order details screen.
- [x] Handle empty state for open orders.

### Phase 4: Navigation Bar ✅
- [x] Implement the bottom navigation bar.
- [x] Create icons for Home, Notifications, Order History, and User Profile.
- [x] Set up routing for each navigation item.

## Current Status
✅ **Authentication Module Complete**: All login, signup, and password recovery features are working
🔄 **Profile Module In Progress**: Initial UI for the profile screen is created
🔄 **Next Step**: Integrate Firestore for complete user data management as per the new plan

## Module 5: Surgery Package Request Flow ✅ COMPLETED

### Phase 0: State Management & Persistence Setup ✅
- [x] Choose and implement a local persistence library (e.g., Hive, SharedPreferences).
- [x] Create a Riverpod provider (e.g., `StateNotifierProvider`) to manage the temporary order state.
- [x] Implement logic to save the order state to local storage on every change and load it on flow entry.

### Phase 1: Procedure Selection (UI Refined) ✅
- [x] Create the main screen `procedure_selection_screen.dart`.
    - [x] Include an `AppBar` with a title and back button.
- [x] Implement a grouped list UI (e.g., `ExpansionTile`) to show `Surgeries` as headers and `Procedures` as items.
- [x] Add a search bar to filter surgeries and procedures in real-time.
- [x] On selecting a procedure, load `templateItems` into the persistent state provider and navigate to the next phase.

### Phase 2: Package Customization ✅
- [x] Create the `package_customization_screen.dart`.
- [x] Read the order data from the persistent state provider.
- [x] Use a `TabBar` or `SegmentedButton` to divide content into "Equipment," "Instruments," and "Consumables."
- [x] Allow the user to modify items, with each change updating the state provider (which then persists automatically).
    - [x] Modify quantity.
    - [x] Remove items from the list.
    - [x] Add new items from a catalog.
- [x] Add a floating or fixed button at the bottom to "Continue."

### Phase 3: Surgery Details (Logistics)
- [ ] Create the `surgery_details_screen.dart`.
- [ ] Add fields for surgery details (date, time, coverage, address, notes).
- [ ] On change, update the corresponding fields in the order object within the state provider.

### Phase 4: Summary and Submission
- [ ] Create the `request_summary_screen.dart`.
- [ ] Display a complete summary by reading the final state from the provider.
- [ ] Upon submission:
    - [ ] Show a loading indicator.
    - [ ] Read the state from the provider and create the final request document in Firestore.
    - [ ] On completion, clear the persisted local state.
    - [ ] Show a confirmation screen (`request_sent_screen.dart`) and navigate the user back to the Homepage.

### Additional Features Implemented ✅
- [x] Product catalog with category grouping
- [x] Product model and provider for efficient data fetching
- [x] Item quantity modification with automatic removal when quantity reaches zero
- [x] Floating action button to add products from catalog
- [x] Visual feedback with snackbars when items are added
- [x] Product images and error handling for missing images
