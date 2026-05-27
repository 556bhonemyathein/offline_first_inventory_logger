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
- path

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
<img width="250" height="1280" alt="image" src="https://github.com/user-attachments/assets/86766657-3ccf-4598-a754-c4dd08507cf9" />
<img width="250" height="1280" alt="image" src="https://github.com/user-attachments/assets/704f5dd7-0ff7-4018-b808-c987ccf8e26f" />


### Add Item Bottom Sheet
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/296c999f-40e8-4923-93e9-0513437bbe08" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/0220cbac-5929-43d7-b5ae-e4a9e4c079cb" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/25c52bd4-5614-4628-8789-57a2fc1a7ce8" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/8fbcb8d8-32d4-4040-9bae-c9048bd9add1" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/225f658e-4736-4328-9a4b-8272d3d4806d" />


### Edit Item Dialog
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/2b099701-e165-489c-97f5-e06e4c618a4d" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/74545e09-28e8-47a3-8548-050896b5f02c" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/c577fdec-6ee3-4fd0-9c86-05739243daa5" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/eea8add2-5016-4945-bccc-42c111f81df1" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/85c39597-4dc9-4725-9fcc-9d6f24800148" />


### Delete Item Dialog
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/538b13dd-39a4-49c7-8f3a-e9af7afd444d" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/101b3975-ec2b-4f73-9835-cd113fe6b134" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/f3a17b6d-578a-4468-b70a-b9662b7584f8" />


---

## Run Project

```bash
flutter pub get
flutter run
