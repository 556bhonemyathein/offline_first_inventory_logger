# Offline First Inventory Logger

A Flutter mobile application that manages inventory items locally using SQLite while fetching suppliers from a REST API.

---

## Features

- Fetch suppliers from REST API
- Add inventory items
- Edit inventory items
- Delete inventory items
- Offline local storage with SQLite
- Swipe actions using Slidable
- Form validation
- Loading and network error handling
- Clean architecture with Riverpod

---

## Tech Stack

- Flutter
- Riverpod
- Dio
- Sqflite
- Flutter Slidable
- Intl
- Logger

---

## Architecture

This project follows clean architecture principles.

UI → Provider → Repository → Service → Database/API

### Layers

- UI Layer  
  Screens, dialogs, widgets

- Provider Layer  
  State management using Riverpod

- Repository Layer  
  Handles communication between provider and services

- Service Layer  
  API and SQLite operations

- Model Layer  
  Data models

---

## Why Riverpod?

Riverpod was chosen because it provides:

- Clean dependency injection
- Scalable state management
- Better testability
- Improved code organization

---

## Folder Structure

lib/
├── controller/
├── data/
│ ├── repositories/
│ └── services/
├── model/
├── view/
│ ├── screens/
│ └── widgets/

---

## Screenshots

### Home Screen

![Home](screenshots/home.png)

### Add Item Bottom Sheet

![Add](screenshots/add.png)

### Edit Item Dialog

![Edit](screenshots/edit.png)


### Delete Item Dialog
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/101b3975-ec2b-4f73-9835-cd113fe6b134" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/f3a17b6d-578a-4468-b70a-b9662b7584f8" />


---

## Run Project

```bash
flutter pub get
flutter run
