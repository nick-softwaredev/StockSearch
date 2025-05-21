# 📱 ProjectName

An iOS application that allows users to search stocks in realtime time and viewing average and current price 

---

## 🚀 Setup Instructions

### Requirements
- macOS 13.0 or higher
- Xcode 16+
- iOS 16.0+
- Swift Package Manager (SPM)

### Installation

1. Clone the repository:

https://github.com/nick-softwaredev/StockSearch

2. open StockSearch.xcodeproj
3. Wait for package resolution or resolve manually if needed
4. Build and run! 


## 🚀 Project Overview

### Architectural Overview

This project organized to adopt best CLEAN SOLID and DI principles and organized in Core, Data, Domain, Presentation Layers to enable testability, maintainability scalability and modularity. 

Presentation Layer follows Navigation Path Coordinator + MVVM pattern with UseCase being business logic driver and ViewModel as view state renderer as it fits the main app needs perfectly and is native approach to SwiftUI based app.

Other possible consideration was TCA(https://github.com/pointfreeco/swift-composable-architecture), but there is a bit of implementation overhead for such small app as well as harder to display architectural nuances understanding on a basic level. 

### Implementation Overview 

Given the are no sockets or dedicated backend api to perform search and get part of the data via query and paginations, this app relies on a data provided by a several static json files urls, thus networking is implemented in a simple way of downloading the files. Current data file assumed by me to be updated in realtime in production, thus it is not cached and is being fetched to get most recent information as no specific details are provided. Other file for historical data is assumed to be  not changing that frequently and thus cached via NSCache during app session as most simple and effective approach given no constraints were set for the data. 

## Complexity  

Merging of the data done with help of hash map (dictionary) to achieve proper performance. 

Searching done over name and ticker based on query and utilizes lazy array with cut off prefix to allow limited amount of values to be retrieved from the data and exit search early (inspired by iOS Stock app) and optimizing performance. Result sorting based on query lengths, with 2 or less characters ticker assumed being a priority. The performance is covered by unit tests. 


## UX, UI updates and rendering  

The search action utilizes denounce to prevent unneeded requests as well as handles search cancellation task to optimize rendering. The views are split in subviews to help manage and build flows. As this app follows iOS Stock App UX, there is no search loader present but rather request timeout is set to be expiring fast giving user view state explaining the result of action / error communication. Edge cases like empty searches ignoring and no internet connection as supported during user input.

The design is very simple resembling design of Stocks app with minor adjustment and hig in mind. 

## 🚀 Testing 

The app has some unit test coverage for ViewModel, UseCase, Services and Helper(Merging, Searching, Debounce) as crucial business and logic layers for app successful deployment. 

To run tests, simply CMND+U or run manually desired tests from test target files.

## 🚀 3rd party Dependancies  

The only dependancy used in the app is Resolver(https://github.com/hmlongco/Resolver), it greatly helps with dependency injection, gives centralized management for it and prevents boiler plate code. It is utilized in app, but can also be used or integration tests with ease. 