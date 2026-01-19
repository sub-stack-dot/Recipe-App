# Updated Navigation Flow

## App Flow

1. **Landing Page (Initial Screen)**
   - Single attractive food item displayed
   - Animated swipe left indicator with arrow
   - Tap food item → View full recipe details
   - Swipe left → Navigate to Login page

2. **Login Page**
   - Email and password fields
   - Fill in details and tap "Log In"
   - Success message appears (green snackbar)
   - Auto-navigates to Home page after 1 second
   - Error message if fields are empty

3. **Sign Up Page**
   - Can be accessed from Login page
   - Name, email, password, confirm password fields
   - Accept terms checkbox required
   - Validates password match
   - Shows success message on creation
   - Auto-navigates to Home page after 1 second
   - Error messages for validation failures

4. **Home Page**
   - Main app where user can browse recipes
   - Access to all recipe categories and search

## Key Implementation Details

### Landing Page (`landing.dart`)
- Shows only the first recipe from sample data
- Swipe left gesture detection (velocity-based)
- Animated arrow indicator that scales up and down
- Original styling maintained
- Tap recipe opens recipe detail view

### Login Screen (`login.dart`)
- Added validation to check if email and password are filled
- Success SnackBar with green background
- Auto-navigation to home page after 1 second delay
- Error SnackBar if fields are empty
- Uses `pushNamedAndRemoveUntil` to prevent going back

### Sign Up Screen (`signin.dart`)
- Validates all fields are filled
- Checks if passwords match
- Requires terms acceptance
- Success SnackBar on account creation
- Auto-navigation to home page
- Error messages for different validation failures
- Uses `pushNamedAndRemoveUntil` to prevent going back

## Navigation Routes

```dart
'/landing' → LandingPage()
'/login'   → LoginScreen()
'/signup'  → SignUpScreen()
'/home'    → HomeScreen()
```

## User Experience Flow

```
App Launch
    ↓
Landing Page (Single Food Item)
    ↓ [Tap Food] → Recipe Detail Page
    ↓ [Swipe Left] → Login Page
        ↓
    Login/Sign Up
        ↓ [Enter Details] → Success Message → Home Page
            ↓
        Home Screen (Browse Recipes)
```

## SnackBar Messages

### Login Success
- Message: "Login Successful!"
- Color: Green
- Delay before navigation: 1 second

### Sign Up Success
- Message: "Account Created Successfully!"
- Color: Green
- Delay before navigation: 1 second

### Login/SignUp Errors
- Empty fields: "Please fill in all fields" (Red)
- Password mismatch: "Passwords do not match" (Red)
- Missing terms acceptance: "Please fill in all fields and accept terms" (Red)
