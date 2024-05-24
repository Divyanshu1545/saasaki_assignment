# saasaki_assignment

## Overview
This Flutter application integrates Firebase Authentication for OTP verification and Firestore for storing and managing tasks. Each user has a separate collection of tasks in Firestore.

## Features
- **Firebase Authentication:**
  - Phone number OTP verification.
  - Automatic redirection to home screen if the user is already logged in.
  
- **Task Management:**
  - Add new tasks with details such as title, description, deadline, and expected duration.
  - Edit existing tasks with pre-filled information.
  - Mark tasks as completed.
  - Delete tasks.
  - Each user has a separate collection of tasks in Firestore.
  
- **User Interface:**
  - Splash screen for initial loading and authentication check.
  - Registration screen for phone number input.
  - OTP verification screen.
  - Home screen displaying a list of tasks with options to add, edit, delete, and mark tasks as completed.
  - Add Task screen with date and time picker combined into one selector for setting deadlines.
  
- **State Management:**
  - Uses Flutter Provider for managing authentication and task states.

