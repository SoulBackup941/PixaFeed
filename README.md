# iOS Project: PixaBay

PixaBay is an iOS app designed using modern development practices and architectural approaches. The application consists of four main screens: Login, Registration, Home Feed, and a Detail Page, providing a seamless and intuitive user experience.

## Features

- **Login Screen:** Mock login. Fields are validated using validators.
- **Registration Screen:** Mock Registration logic. Fields are validated using validators.
- **Home Feed:** A dynamic endless feed of PixaBay API. 
- **Detail Page:** Detailed page of PixaBay image, with full resolution image, ability to share with long press.

## Architecture & Technologies

This project is built using the following key technologies and architectural patterns:

- **Model-View-ViewModel (MVVM):** Ensures a clean separation of concerns, with reactive updates.
- **Clean Architecture:** Promotes a scalable, maintainable, and testable codebase.
- **Combine Framework:** For handling asynchronous events by combining sequences of values over time.
- **Modern Concurrency:** Utilizes Swift's latest concurrency features (async/await) for efficient and safe multithreading.
- **Dependency Injection:** Allows for more modular and testable code.
- **Unit Tests:** Ensures robustness and reliability of the code through extensive unit testing.

## Installation

```bash
git clone https://github.com/[YourGitHubUsername]/PixaBay.git
cd PixaBay
```

_Instructions for dependency installation, if any, such as CocoaPods, Carthage, or Swift Package Manager._

## License

"Distributed under the MIT License. See `LICENSE` for more information."
