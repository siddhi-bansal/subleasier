# Subleasier

Make subleasing easier with Subleasier!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Personal Notes

I will use this README to track To-Dos and pending items for now.

1. Email Sublessor Button has not been tested (since iOS emulator does not have Mail app)
2. Add User Profiling (users should be able to create profiles)
3. Add Firebase Authentication (currently, anyone can edit my database since I haven't added authentication. once users are logging in, I will add authentication so that only users logged in through the app can access my database.)
4. Add 'Chat with Sublessor' option (sublessee should be able to chat with sublessor on the app itself)
5. Replace Firebase Frequent Polling with Realtime-Updates (right now, I query to Firebase everytime the Postings Listings screen is built. ideally, I want to only query to Firebase if any changes have been made to the database.)
6. Test on Android (need to set up Android emulator, after which I need to test all the functionality on Android)
7. Look into how to make code production ready

## AI Applications

### Use-Cases/Applications (in order of implementation):
1. Image recognition to use AI to analyze/tag images of apartments highlighting amenities, overall condition
2. Predict fair market value
4. Chatbot assistance to help with finding suitable listings
5. Add image cards to Gemini chat feature

### Future Considerations:
1. Sublessees can navigate neighborhood of apartment
2. Customize sublease contracts based on user inputs
3. Image recognition to verify authenticity of images uploaded by users (prevent fraud)
