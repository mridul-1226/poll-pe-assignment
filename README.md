# Poll Pe - Flutter Voting App

## Overview
Poll Pe is a feature-rich voting application built using Flutter, designed to let users participate in polls, cast votes, and view results in real-time. The app supports a clean and interactive UI that displays polls with multiple voting options, dynamically updates voting counts, and provides an engaging experience with options to view voting distributions visually. Built using the Clean Architecture pattern, Poll Pe is modular, scalable, and easy to maintain.

## Key Features
- **Vote on Polls**: Users can view a list of polls and cast votes on different options.
- **Real-Time Voting Distribution**: After casting a vote, users can view a bar graph that displays the percentage distribution of votes for each option, which updates dynamically.
- **Comments on Polls**: Users can add comments on polls, and the app displays the comment list in real-time.
- **Dynamic Modal View**: The app uses a two-page modal for easy navigation between voting options and visual representation of voting results.
- **Persistent Storage**: Polls, votes, and comments are stored locally using Hive, enabling offline access and ensuring data is preserved across sessions.
- **Clean Architecture**: The app is built following the Clean Architecture principles, making it highly modular and scalable.

## Objective
The objective of Poll Pe is to provide a seamless experience for users to interact with polls, cast votes, and view results in a clean, real-time UI. The app aims to demonstrate the use of state management, clean architecture, and persistent local storage to build a highly interactive and responsive Flutter application.

## Requirements and Setup

### Prerequisites
- Flutter SDK: ">=3.5.1 <4.0.0"
- Dart >= 2.17.0
- Hive for local storage
- `flutter_bloc` for state management
- `fl_chart` for dynamic bar chart visualization

### Installation
1. **Clone the Repository**:
    ```bash
    git clone https://github.com/mridul-1226/poll-pe-assignment
    cd poll-pe
    ```

2. **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3. **Run the App**:
    ```bash
    flutter run
    ```

## Project Architecture

### Architecture Followed: Clean Architecture
Poll Pe follows the Clean Architecture pattern to ensure scalability, testability, and separation of concerns. The architecture is divided into three main layers:

1. **Domain Layer**: Contains business logic and entities.
   - **Models**: Core data models like `Post` and `VoteOption`.

2. **Data Layer**: Responsible for data management (Can be used when using firebase or any other back-end services).
   - **Repositories**: Interfaces that define the contract for data access.
   - **Data Sources**: Uses Hive for local data storage and retrieval.

3. **Presentation Layer**: Manages the UI and state.
   - **Cubit/Bloc**: Manages state for polls, comments, and voting.
   - **Widgets**: Displays UI components, utilizing real-time data updates.

This architecture ensures a high degree of separation, allowing easy testing and maintenance.

## State Management

State management is handled using **BLoC (Business Logic Component)** and **Cubit** from the `flutter_bloc` package. Key areas where BLoC/Cubit is applied:
- **PostCubit**: Manages individual post actions like adding comments and casting votes.
- **FeedCubit**: Manages the list of posts and updates the feed screen whenever there's a change in state (like a new comment or vote).

BLoC/Cubit enables Poll Pe to have a predictable and testable state management system, with real-time UI updates across different parts of the app.

## User Guide

### Navigating the App
1. **View Polls**: The home screen displays a list of active polls, each with a title, description, and image.
2. **Vote on Polls**: Tap on a poll to open a modal with the voting options. Select an option to cast your vote.
3. **View Voting Distribution**: After voting, you can view a bar graph showing the percentage of votes each option received.
4. **Add Comments**: In the poll modal, users can add comments, which are saved and displayed in real-time.

### Switching Between Voting and Graph View
- **Vote Modal**: After selecting a poll, you’ll see the voting options. Below the options, there’s a button to switch to the bar graph.
- **Graph View**: The bar graph view displays the vote distribution. A “Back to Options” button allows users to return to the voting page.

## Versioning
The app uses Git for version control. Ensure regular commits for changes and maintain clear commit messages to document progress and updates.

Current version: **v1.0.0**

## Conclusion
Poll Pe showcases how Flutter can be used to build a dynamic and interactive voting application with real-time updates. Using Clean Architecture, BLoC/Cubit for state management, and Hive for local storage, this project is highly modular and scalable, making it ideal for future enhancements and modifications. Whether you’re learning about state management, Flutter’s architecture patterns, or interactive UI design, Poll Pe serves as a comprehensive example of building robust applications with Flutter.
