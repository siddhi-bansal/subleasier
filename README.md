# subleasier

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

I will use this README to track To-Dos and pending items for now.

1. Email Sublessor Button has not been tested (since iOS emulator does not have Mail app)
2. Improve App Navigation (right now, the only navigation available to the user is through the back buttons, which also doesn't reset the form. this navigation needs to be better so that the user can easily access screens of interest.)
2. Add User Profiling (users should be able to create profiles)
3. Add Firebase Authentication (currently, anyone can edit my database since I haven't added authentication. once users are logging in, I will add authentication so that only users logged in through the app can access my database.)
4. Add 'Chat with Sublessor' option (sublessee should be able to chat with sublessor on the app itself)
5. UI Changes (basic formatting changes)
6. Replace Firebase Frequent Polling with Realtime-Updates (right now, I query to Firebase everytime the Postings Listings screen is built. ideally, I want to only query to Firebase if any changes have been made to the database.)
7. Test on Android (need to set up Android emulator, after which I need to test all the functionality on Android)
8. Add Bathroom information to form and posting
9. Add other option to dropdown, parse the input, and save to database
10. Implement URL functionality for 'other' apartment option
11. Look into how to make code production ready
