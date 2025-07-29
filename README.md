# 🏆 iOS Sports App

A native iOS app built with **MVP architecture** to explore sports leagues, teams, fixtures, and manage favorites with offline support.

---

## 📌 Features
- Browse sports: Football, Cricket, Tennis, Basketball  
- View leagues & fixtures with detailed info  
- Team profiles & player rosters  
- Save/remove favorites (Core Data)  
- Offline persistence & network monitoring  

---

## 🏗 Architecture
- **MVP** with clear separation of concerns  
- **Repository Pattern** for unified data access  
- **Data Sources**:  
  - `SportsAPIService` (remote, Alamofire)  
  - `LeaguesLocalDataSource` (Core Data)  

---

## 📡 Tech Stack
- **Swift**, iOS 16.2+  
- **SPM** for dependency management  
- **Libraries**: Alamofire, Kingfisher, Lottie, SkeletonView  

---

## 🧪 Testing
- **Unit Tests**: API & repository  
- **UI Tests**: Navigation & flows  

---

## 🚀 Setup
```bash
git clone https://github.com/<your-username>/iOS-Sports-App.git
open Sports\ App.xcodeproj
