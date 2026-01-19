# Firebase Setup Guide

## Prerequisites
- Firebase project created at https://console.firebase.google.com
- Android app registered in Firebase console
- iOS app registered in Firebase console (if targeting iOS)

## Setup Steps

### 1. Android Configuration ✅
- `google-services.json` already added to `android/app/`
- Ensure package name matches: `com.example.flutter_application_1`

### 2. iOS Configuration (TODO)
1. Download `GoogleService-Info.plist` from Firebase console
2. Add to `ios/Runner/` directory
3. Update `Info.plist` with Firebase configuration

### 3. Enable Firebase Services
In Firebase Console:
1. **Authentication**
   - Enable Email/Password authentication
   - Go to Authentication > Sign-in method > Email/Password > Enable

2. **Firestore Database**
   - Create database in production mode
   - Set up security rules (see below)

3. **Storage** (Optional)
   - Enable Firebase Storage for recipe images
   - Set up security rules

### 4. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Recipes collection
    match /recipes/{recipeId} {
      allow read: if true; // Public read
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         request.auth.token.admin == true);
    }
    
    // Comments collection
    match /comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

### 5. Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /recipe_images/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /profile_images/{userId}/{imageId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 6. Seed Initial Data

Run this once to populate your database with sample recipes:

```dart
import 'package:flutter_application_1/utils/seed_data.dart';

// In your app, call once after Firebase is initialized
await seedRecipes();
```

Or manually add recipes through Firebase console.

### 7. Install Dependencies

```bash
flutter pub get
```

### 8. Run the App

```bash
flutter run
```

## Database Structure

### Users Collection
```
users/{userId}
├── uid: string
├── name: string
├── email: string
├── profileImage: string (optional)
├── favorites: array of recipe IDs
└── createdAt: timestamp
```

### Recipes Collection
```
recipes/{recipeId}
├── title: string
├── description: string
├── imageUrl: string
├── author: string
├── servings: string
├── prepTime: int
├── category: string
├── userId: string (creator)
├── ingredients: array (optional)
├── instructions: array (optional)
└── createdAt: timestamp
```

### Comments Collection (Future)
```
comments/{commentId}
├── recipeId: string
├── userId: string
├── userName: string
├── text: string
└── createdAt: timestamp
```

## Testing

1. **Sign Up**: Create a new account
2. **Sign In**: Login with your credentials
3. **Browse Recipes**: View all recipes from Firestore
4. **Add to Favorites**: Toggle favorites (syncs with Firestore)
5. **Search**: Search recipes by title/description
6. **Filter**: Filter by category

## Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Error: `[core/no-app]`
   - Solution: Ensure `await Firebase.initializeApp()` is called in `main()`

2. **Missing google-services.json**
   - Error: Build fails on Android
   - Solution: Download from Firebase console and place in `android/app/`

3. **Authentication errors**
   - Ensure Email/Password is enabled in Firebase Console
   - Check error messages for specific issues

4. **Firestore permission denied**
   - Update security rules in Firebase Console
   - Ensure user is authenticated

5. **No recipes showing**
   - Check Firestore console to verify data exists
   - Run `seedRecipes()` to add sample data
   - Check console for error messages

## Next Steps

- [ ] Add iOS Firebase configuration
- [ ] Implement recipe creation UI
- [ ] Add image upload functionality
- [ ] Implement comments system
- [ ] Add push notifications
- [ ] Implement social sharing
