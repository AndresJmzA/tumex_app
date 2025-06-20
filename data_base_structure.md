# Firebase Firestore Data Structure

This document outlines the data structure for the collections in Cloud Firestore.

## `users`

Stores public and private information for each user. The document ID will be the same as the Firebase Authentication User ID (UID).

### Document Fields

- **uid**: `string` - The user's unique ID from Firebase Auth.
- **email**: `string` - The user's email address (locked after sign-up).
- **fullName**: `string` - The user's full name.
- **phone**: `string` - The user's contact phone number.
- **position**: `string` - The user's role (e.g., "Doctor", "Admin").
- **onboardingComplete**: `boolean` - Flag to check if the user has completed the initial onboarding flow. Defaults to `false`.
- **createdAt**: `Timestamp` - Server timestamp of when the user document was created.
- **profilePhotoUrl**: `string` (optional) - URL to the user's profile picture stored in Firebase Storage.
- **medicalSpecialty**: `string` (optional) - The user's medical specialty.
- **professionalLicense**: `string` (optional) - The user's professional license number.
- **clinicName**: `string` (optional) - The name of the clinic or hospital the user is affiliated with.
