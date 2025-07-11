# 📱 StockSearch

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

Merging of the data done with help of zip to achieve proper performance, because the data structured for both apis in aligned way with same positions with only difference being the price value. 

Searching done over name and ticker based on query and utilizes lazy array with cut off prefix to allow limited amount of values to be retrieved from the data and exit search early (inspired by iOS Stock app) and optimizing performance. Result sorting based on query lengths, with 2 or less characters ticker assumed being a priority. The performance is covered by unit tests. 


## UX, UI updates and rendering  

The search action utilizes denounce to prevent unneeded requests as well as handles search cancellation task to optimize rendering. The views are split in subviews to help manage and build flows. As this app follows iOS Stock App UX, there is no search loader present but rather request timeout is set to be expiring fast giving user view state explaining the result of action / error communication. Edge cases like empty searches ignoring and no internet connection is supported during user input.

The design is very simple resembling design of Stocks app with minor adjustment and hig in mind. 

## 🚀 Testing 

The app has some unit test coverage for ViewModel, UseCase, Services and Helper(Merging, Searching, Debounce) as crucial business and logic layers for app successful deployment. 

To run tests, simply CMND+U or run manually desired tests from test target files.

## 🚀 3rd party Dependancies  

The only dependency used in the app is Resolver(https://github.com/hmlongco/Resolver)

It greatly helps with dependency injection, gives centralized management and prevents boiler plate code. It is utilized in app, but can also be used for integration tests with ease. 

## Reflection 
If valid backend communication would be present, I would probably be able to cache save the response for the searches or preffered user stocks and only render / update the price value on the view coming from something like socket connection and have placeholders for price like Stocks App, that would remove need for on device merging from 2 sources. I would also be able to utilize partial loads from backend thus most likely would not need to rely on my on device search that much. Also, in real app I would cover app with some potential integration tests as well as add analytics tools to record performance as well as implement remote configs to support dynamic view composition or many other things. The current app structure also allows me to use this as standalone module and expose protocols or shared module helpers and objects to be able to work on there features isolated and standalone. Final minor change id might consider supporting is adding observation for network state globally across app and introduce dynamic monitoring rather as only during seach type.

For testing, i would add integration tests as well general ui test for common flows. 
