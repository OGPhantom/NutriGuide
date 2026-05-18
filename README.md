# 🥗 NutriGuide
A **premium AI-powered nutrition coach for iOS** built with **SwiftUI**, **SwiftData**, **OpenAI Vision**, and **Apple Intelligence (FoundationModels)**.  
Scan your **meals with the camera**, review estimated **calories and macros**, and generate **personalized AI nutrition insights** from your recent food history.

---

### 📌 Short Description

NutriGuide is a premium wellness-focused iOS app built for **camera-first meal tracking**, **AI-powered food analysis**, and **personalized nutrition coaching**.  
Users can capture or select a meal photo, review automatically estimated **calories, protein, fat, carbs, ingredients, and meal type**, then save the result into a local food diary.
The app combines a polished **editorial wellness interface** with practical nutrition tools: a daily summary, recent meal timeline, calendar-based diary, searchable meal history, editable nutrition profile, and an **AI Coach Summary** generated from recent logged meals.

---

### 🚀 Why NutriGuide

- 📸 Camera-first meal logging with minimal manual input
- 🤖 AI-powered food recognition and nutrition estimation
- 🧠 On-device AI Coach insights powered by Apple Foundation Models
- 🔒 Local-first meal history and nutrition profile storage with SwiftData

---

## 📹 App Demo

[Watch Demo](https://drive.google.com/file/d/1pIcX0tcQkSxVmD4NcGsqZPF6verq9VOz/view?usp=sharing)

---

## ✨ Features

- 📷 **Custom full-screen camera flow** with shutter, flash, close, and library actions
- 🖼 Analyze newly captured or selected **meal photos**
- 🤖 Estimate **dish name, calories, protein, fat, carbs, and ingredients** using OpenAI Vision
- ✅ Review AI results before saving with editable title, calories, macros, ingredients, and meal type
- 🍽 Choose **meal type manually** with smart time-based preselection
- 💾 Store saved meals locally with **SwiftData**
- 🏠 View a premium **Home dashboard** with scan CTA, daily nutrition summary, and recent meals
- 📊 Track daily calories and macros against editable targets
- 🕰 Browse recent meals through an editorial timeline layout
- 🔎 Search and filter all saved meals by **dish name, ingredients, and meal type**
- 📅 Use a calendar-first **Diary** screen for day-specific meal history
- 🧠 Generate **AI Coach Summary** for the last 7 calendar days using Apple Foundation Models
- 🍩 Review **7-day average macro balance** with a donut-style visual chart
- 💡 Receive exactly **three personalized nutrition recommendations**
- 👤 Edit nutrition profile: display name, sex, age, height, weight, activity level, and goal
- 🎯 Edit daily targets manually or calculate them from profile data
- ⚙️ Configure units with Metric / Imperial display support
- 🧾 Access secondary profile screens for privacy and app information

---

## 🛠️ Tech Stack

iOS
- **SwiftUI**
- **SwiftData**
- **AVFoundation**
- **PhotosUI**
- **Foundation**

AI
- **OpenAI Vision API**
- **Apple Intelligence / FoundationModels**

Architecture & UI
- **Feature-first modular architecture**
- **MVVM-style presentation logic**
- **Observation (`@Observable`)**
- **Native iOS navigation and sheet patterns**
- **SF Symbols**
- **Premium editorial wellness design system**

---

## 📄 Requirements

- Xcode 26+
- iOS 26.2+
- Camera access for meal capture
- Photo library access for gallery selection
- OpenAI API key for food image analysis
- Apple Intelligence-supported device or simulator setup for AI Coach insights

---

## 🚀 Installation

1. Clone the repository.
2. Open `NutriGuide.xcodeproj` in Xcode.
3. Add your OpenAI API key through the project configuration used by `OPENAI_API_KEY`.
4. Build and run on an iPhone simulator or physical device.
5. Grant **camera** and **photo library** permissions when prompted.
6. For AI Coach insights, run on an environment that supports Apple Intelligence / FoundationModels.

---

## 🧠 Notes

- Saved meals, ingredients, profile data, daily targets, and the latest AI Coach Summary are stored locally with **SwiftData**.
- Meal photos are **not persisted** after review/save; images only exist during capture, analyzing, and review flow.
- OpenAI Vision is used only for meal photo analysis.
- Apple Foundation Models are used for on-device AI Coach Summary generation.
- AI Coach generation requires at least **3 meals across 2 different days** in the last 7 calendar days.
- If Apple Intelligence / FoundationModels are unavailable, the rest of the app remains functional.
- For production, OpenAI API calls should be moved behind a backend because bundled client API keys can be exposed.
