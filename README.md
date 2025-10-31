# TaskFlow

TaskFlow is a SwiftUI field operations app that combines Firebase-backed task management, Supabase media storage, and rich on-device tooling to help teams plan, execute, and document work from an iOS device.

## Tech Stack
- **SwiftUI & SwiftData** for the primary UI layer and local persistence of tasks, checklists, and attachments.
- **Firebase (Auth & Firestore) with Google Sign-In** for authentication and cloud synchronization of task records.
- **Supabase Storage** to mirror task media between the device and the cloud, preventing duplicate uploads and downloads.
- **MapKit, CoreLocation & Network** frameworks for location selection, monitoring, and connection-aware syncing.
- **PhotosUI, AVKit & PDFKit** to capture on-site evidence and render shareable PDF reports.
- **UserNotifications** for deadline reminders that respect user preferences.

## Features
- **Secure authentication** – Email/password sign-in & sign-up with validation, error messaging, and Google Sign-In funnel users into the workspace once authenticated.
- **Tabbed workspace** – A five-tab layout jumps between the dashboard, task list, location tools, reports, and settings screens.
- **Dashboard metrics & syncing** – Visual task counts, quick shortcuts, manual sync controls, and network-driven background sync keep data fresh.
- **Cloud-synced tasks** – A dedicated sync manager mirrors SwiftData tasks (including location, checklists, and work items) to and from Firestore.
- **Task management** – Browse outstanding versus completed tasks, open detailed records, delete items, seed mock data (developer role), and let admins create new work.
- **Task creation with location intelligence** – Guided forms validate required fields, capture map positions via search or current location, and optionally schedule deadline notifications.
- **Rich task details** – Track progress states, edit to-do descriptions, manage review checklists, view or fullscreen media, advance workflow, or export the task as a PDF report.
- **On-site evidence capture** – Add text notes, attach photos, and import videos, all persisted in SwiftData and synced to Supabase to keep remote copies in sync.
- **Automated reminders** – Notification preferences drive scheduling or clearing of deadline alerts when new tasks are saved.
- **Report archive** – Generate PDFs from task content, list them in-app, open a viewer, share externally, or delete outdated files.
- **Location overview** – Inspect current coordinates alongside permission and service status when working in the field.
- **Personalized settings** – Switch themes, fine-tune sync modes, toggle notifications, change the user role, or log out from one place.
- **Network awareness** – App-wide environment values expose connectivity and interface type so the dashboard can react to offline states.
- **App lifecycle integration** – Firebase configuration, notification permission requests, and network monitoring are wired up at launch.

## Project Structure
- **`TaskFlow/App/`** – App and application delegate entry points that configure Firebase, notifications, and shared SwiftData storage.
- **`TaskFlow/Features/`** – Feature-specific SwiftUI screens and view models (Auth, Dashboard, Tasks, Location, Reports, Settings, Tab bar).
- **`TaskFlow/Shared/`** – Shared models, UI components, enums, utilities, and services used across features.

## Getting Started
1. **Requirements** – Xcode 15 or later with the iOS 17 SDK is recommended for SwiftData and the latest SwiftUI APIs used in the project.
2. **Firebase setup** – Add your `GoogleService-Info.plist` to the `TaskFlow` target so `FirebaseApp.configure()` can load credentials, and enable Email/Password plus Google Sign-In in the Firebase console.
4. **Build & run** – Open `TaskFlow.xcodeproj`, select the **TaskFlow** scheme, and run on an iOS 17 simulator or device to launch the authentication flow and reach the tabbed workspace.
5. **Optional services** – Grant notification permission on first launch to test deadline reminders, and enable location access to use the map picker and location dashboard.

## Demo
| Sign Up | Log out |
|:--:|:--:|
|<video src="https://github.com/user-attachments/assets/32f333f0-f976-42f3-b95d-39a69a5b1e41" width="300" controls></video>|<video src="https://github.com/user-attachments/assets/3a18c6e5-50b8-464f-9903-e0e7d2550bbf" width="300" controls></video>|

| Task Creation | Task Deletion | Task State Management |
|:--:|:--:|:--:|
| <video src="https://github.com/user-attachments/assets/0c9eb4d7-582a-4e9e-851a-d1546538be1c" width="300" controls></video> | <video src="https://github.com/user-attachments/assets/8814e0a7-60da-4652-92a9-70c91599f174" width="300" controls></video> | <video src="https://github.com/user-attachments/assets/4493f99c-ff97-4165-ae1b-d331141c8d6b" width="300" controls></video> |

| Automatic Sync | Manual Sync |
|:--:|:--:|
| <video src="https://github.com/user-attachments/assets/a40a57be-a57f-4f1d-b0ec-860a55f75bb4" width="300" controls></video> | <video src="https://github.com/user-attachments/assets/38427bf3-0592-4d83-a7d1-91932fd6c3bc" width="300" controls></video> |

| Media Addition | Checklist Item Addition |
|:--:|:--:|
| <video src="https://github.com/user-attachments/assets/da0cbece-4320-4bd3-9371-d866a2a2d3f6" width="300" controls></video> | <video src="https://github.com/user-attachments/assets/0828aa8a-611d-4d4c-b600-438e66745f4c" width="300" controls></video> |

| PDF Reports | 
|:--:|
| <video src="https://github.com/user-attachments/assets/fce68211-9da4-4ee6-9281-1387b30d124e" width="300" controls></video> | 

| Notifications | 
|:--:|
| <video src="https://github.com/user-attachments/assets/346b0d68-ae8c-45a1-a782-28cd7ba7ce86" width="300" controls></video> | 


