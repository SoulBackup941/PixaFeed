# iOS Project: PixaFeed

PixaFeed is an iOS app designed using modern development practices and architectural approaches. The application consists of four main screens: Login, Registration, Home Feed, and a Detail Page, providing a seamless and intuitive user experience.

## Features

- **Login Screen:** Mock login. Fields are validated using validators.
- **Registration Screen:** Mock Registration logic. Fields are validated using validators.
- **Home screen:** A dynamic endless feed of PixaFeed API. 
- **Detail screen:** Detailed screen of PixaFeed image, with full resolution image, can be shared with a long press.

## Screenshots

### Login
<img src="https://github.com/SoulBackup941/PixaFeed/blob/f668f81561a23babd3513700433d073cad709b8f/PixaFeed/Resources/screenshots/login.png" alt="Login Screen" height="500">

### Registration
<img src="https://github.com/SoulBackup941/PixaFeed/blob/f668f81561a23babd3513700433d073cad709b8f/PixaFeed/Resources/screenshots/registration.png" alt="Registration Screen" height="500">

### Home
<img src="https://github.com/SoulBackup941/PixaFeed/blob/f668f81561a23babd3513700433d073cad709b8f/PixaFeed/Resources/screenshots/feed.png" alt="Home Screen" height="500">

### Detail
<img src="https://github.com/SoulBackup941/PixaFeed/blob/f668f81561a23babd3513700433d073cad709b8f/PixaFeed/Resources/screenshots/details.png" alt="Detail Screen" height="500">

## Architecture & Technologies
This project is built using the following key technologies and architectural patterns:

- **Model-View-ViewModel (MVVM):** Ensures a clean separation of concerns, with reactive updates.
- **Clean Architecture:** Promotes a scalable, maintainable, and testable codebase.
- **Combine Framework:** For handling asynchronous events by combining sequences of values over time.
- **Modern Concurrency:** Utilizes Swift's latest concurrency features (async/await) for efficient and safe multithreading.
- **Dependency Injection:** Allows for more modular and testable code.
- **Unit Tests:** Ensures robustness and reliability of the code through extensive unit testing.

## TODO
- Change folder structure to "Screaming Architecture"
- Use separate models for each layer
- Error handling
- Use constants instead for hardcoded values
- Use localized strings
- Add more unit tests
- Add more features

## Installation

```bash
git clone https://github.com/[YourGitHubUsername]/PixaFeed.git
cd PixaFeed
