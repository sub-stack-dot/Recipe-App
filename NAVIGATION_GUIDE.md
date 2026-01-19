# Recipe App Navigation Guide

## Navigation Flow Overview

```
Landing Page (Initial)
├── Swipeable food items
├── Tap food item → Recipe Detail Page
│   ├── Add to Shopping List
│   ├── Share Recipe
│   └── Toggle Favorite
├── Sign In Button → Login Page
└── Create Account Button → Sign Up Page

Login Page
├── Email/Password fields
├── Sign In Button → Home Screen
└── Create Account Link → Sign Up Page

Sign Up Page
├── Name, Email, Password fields
├── Create Account Button → Home Screen
└── Back Button → Previous Screen

Home Screen
├── Browse recipes by category
├── Search recipes
└── View favorites
```

## Implementation Details

### Landing Page (`lib/screens/landing.dart`)
- **Features:**
  - PageView with swipeable recipe cards
  - Animated dot indicators
  - Beautiful gradient backgrounds with theme support
  - Tap recipe to view details
  - Sign In button navigates to LoginScreen
  - Create Account button navigates to SignUpScreen

### Recipe Detail Page (`lib/screens/recipe_detail.dart`)
- **Features:**
  - Full recipe information display
  - Ingredients list with checkboxes
  - Step-by-step instructions
  - Add to Shopping List button
  - Share Recipe button
  - Favorite toggle with provider
  - Responsive theme support
  - Back button to return to previous screen

### Updated main.dart
- **Changes:**
  - Landing Page set as home screen
  - Named routes configured for all screens
  - Material 3 design enabled
  - Dark theme support

### Navigation Routes
```dart
'/landing'  → LandingPage()
'/login'    → LoginScreen()
'/signup'   → SignUpScreen()
'/home'     → HomeScreen()
```

## How to Navigate Programmatically

### Push to a new screen:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RecipeDetailPage(recipe: recipe),
  ),
);
```

### Navigate using named routes:
```dart
Navigator.pushNamed(context, '/signup');
```

### Go back to previous screen:
```dart
Navigator.pop(context);
```

## Theme Support

All pages support both light and dark themes:
- Check brightness with: `Theme.of(context).brightness == Brightness.dark`
- Responsive colors applied throughout
- Orange accent color (#FF6B35) used consistently

## Current User Flow

1. **First Launch:** User sees LandingPage with featured recipes
2. **Browse:** User can swipe through recipes and tap to view details
3. **Authentication:** User can sign in or create account
4. **Main App:** After authentication, user is directed to HomeScreen
5. **Recipe Details:** From any recipe card, user can tap to view full details with ingredients and instructions
