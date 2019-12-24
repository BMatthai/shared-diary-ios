# shared-diary-ios

## What is it ?

This is an iOS mobile application made with Swift for educational purpose.

In this project we had to create a diary in a mobile application. This diary had to be sharable with other users. To perform this, I choose to use Firebase Firestore, that reduce development and integration time.

Data persistence is managed by Firebase Firestore.

## Usage

Open Agenda.xcworkspace file in Xcode. (*Pod install* may be required).

## Notes

1. I didn't join *GoogleService-Info.plist* properly file, which is mandatory as reference and credential for Google Firebase.
So if you decide to use this project, don't forget to re-integrate Firebase/Firestore.

2. I'm aware of remaining bugs/crashes/navigation issues. Since, I worked on it in a limited time, I prioritized features.
