# **cryptox**

An interactive cryptocurrency application showcasing the latest trends in **MVVM (Model-View-ViewModel)** architecture, **SwiftUI**, and advanced API handling. Overall I tried my best to demonstrate strict following to SOLID principles and thrive for simple yet effective logics. I aligned with SwiftUI's principles and provides clean separation of concerns. The app has State-Driven Navigation. The actual navigation logic is decoupled from the View. Instead, navigation decisions are made in the ViewModel or similar state management layer.

---
## 📚 **My Thought Process**
I initially planned to develop this app using **TCA**, and I even experimented with it in a few smaller projects (available on my GitHub). However, since I’m still not as comfortable with TCA as with MVVM, I decided to choose MVVM to highlight what I’m most comfortable with and better demonstrate my overall skill set. If you’d like to see my early TCA experiments, feel free to check my older repos (available on my Github). 

## 📚 **Table of Contents**

- [🖥 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [🔧 Technical Highlights](#-technical-highlights)
- [🚀 How to Run](#-how-to-run)
- [🛠 Technologies Used](#-technologies-used)
- [📈 Improvements](#-improvements)
- [🏁 Conclusion](#-conclusion)

---

## 🖥 **Overview**

Cryptox provides real-time cryptocurrency information, including market trends, price changes, and supply details, while demonstrating clean architecture principles. The app features two primary screens in both Light and Dark mode:

1. **Cryptocurrency List Screen**  
   Displays a list of popular cryptocurrencies with dynamic price changes and a visually appealing UI.
   
2. **Details Screen**  
   Provides in-depth details about a selected cryptocurrency, including market cap, volume, and 24-hour price changes.

![demo-gif](https://github.com/user-attachments/assets/16ac9725-c762-411a-96f8-90c79eae2cbd)


---

## ✨ **Key Features**

- **MVVM Architecture**  
  Employs a modular, testable, and scalable MVVM design for separation of concerns.

- **Dynamic Navigation**  
  Powered by state-driven navigation using `@Published` properties and `NavigationStack`.

- **Reusable Components**  
  Modular views like `CoinListRowView` and `CustomTextView` ensure scalability and consistent UI.

- **Live Data Updates**  
  Reflects real-time market data changes, with formatted values for user-friendly readability.

- **Test Coverage**  
  Around 70% of coverage with comprehensive unit tests, while view-specific tests are yet to be implemented.
---

## 🔧 **Technical Highlights**

### **1. MVVM Architecture**
- **Models**: Encapsulate API responses (**CoinNetworkModel**) and domain logic (**CoinModel**). The domain model, by definition, is what the apps functionality and communication mainly depends on.
- **ViewModels**: Manage business logic and navigation, exposing observable properties for SwiftUI bindings.
- **Views**: Declaratively render the UI with **SwiftUI** bindings.

### **2. Navigation Management**
- Implements state-driven navigation using **NavigationState** and **AppRoute**.

### **3. Network Layer**
I divided my network layer into three distinct stages to ensure a clean and scalable structure. Here's a breakdown of each stage:
- **APIClient**
This stage is solely responsible for fetching raw data from the network. It serves as a lightweight client that performs the basic job of making HTTP requests and retrieving responses. Once the raw data is fetched, it hands over this data to the next stage for processing.
- **APIManager**
This stage is the intermediary layer responsible for handling and processing the raw data received from the `APIClient`. Its key responsibilities include:
    - Decoding the raw data into usable network models.
    - Handling specific status codes and errors (e.g., token expiration, unauthorized access).
    - Displaying relevant App-level pop-ups or alerts, if necessary.
- **ServiceClassr**
This stage is the topmost layer of the network stack, interacting directly with the `ViewModels`. This layer handles:
    - Defining and managing API endpoints.
    - Placing actual API calls to fetch or manipulate data.
    - Centralizing error handling to ensure uniform responses across the app.
    - 
This is the layer where all interactions with the `ViewModel` take place, bridging the gap between the network stack and the UI logic. When the app grows, more services are created with each pointing to its own use case.

### **4. Error Propogation**
Errors are propagated through all three layers. No error management is done in the lower layers as we didn't have any functionality to implement in this app's scope. However you could catch the error at any time on any layer to do what is needed. Currently the error propogates directly to viewmodel to show, **screen-level popups** or alerts.

###### Why I went with this 3 layer approach? 🤔
- **Separation of Concerns**: Each layer has a focused responsibility, which ensures clarity and modularity.
- **Testability**: Isolating network calls, decoding, and service interactions makes each component easier to test individually.
- **Scalability**: Adding new features or API endpoints becomes simpler without risking the integrity of the entire stack.

By structuring the network layer in this way, we ensure a robust, maintainable, and developer-friendly architecture that aligns with modern development practices.

## 🚀 **How to Run**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Hasan-codeislife/Cryptox
   ```
   
2. **Open the project in Xcode:**
   ```bash
   cd cryptox
   open Cryptox.xcodeproj
   ```

3. **Run the project:**
   - Select a simulator or a connected device.
   - Build and run the app using `Cmd + R`.
---

## 🛠 **Technologies Used**

- **SwiftUI**: Declarative UI framework for modern app design.
- **MVVM**: Architecture for clean separation of concerns.
- **Dependency Injection**: For scalable and testable code.
- **Mock Services**: Simulate API responses in tests.
- **Swift Testing**: For unit tests.

---

## 📈 **Improvements**

- **Error Messaging**: Add user-friendly error messages with retry options for API failures.
- **UI Tests**: Automate end-to-end tests to validate the user experience.
- **Performance Optimization**: Improve loading times for large datasets.
- **Performance Optimization**: The size values of setting views like various heights and widths etc are inline. This can be extracted to a class that maintains the whole apps size and dimension of each and every view.
- **Network Layer separate module**: Move the entire network layer (APIClient, APIManager, and Service Layer) into its own dedicated module. This will improve separation of concerns, making the network code independent of the app's core logic.
- **Extras**
    - I couldn’t see the api directly returning URLs so I added them manually which normally shouldn’t be the case.
---

## 🏁 **Conclusion**

Cryptox showcases:
- **Scalable architecture (MVVM)** for modern iOS development.
- **SwiftUI mastery** with reusable components and dynamic UI updates.
- **Unit Tests** for robust and reliable code.

Feel free to explore the project, provide feedback, or contribute to its growth. 🚀
