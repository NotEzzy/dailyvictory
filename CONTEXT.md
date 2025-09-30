# DailyVictory - Productivity App

## 🎯 Overview

DailyVictory is designed to help users focus on one task at a time, manage daily habits and goals, and maintain motivation through consistent progress. Drawing inspiration from popular productivity applications like **Streaks**, **Habitica**, and **Habitify**, it delivers a clean, engaging experience for:

- Tracking task completion
- Forming healthy habits
- Celebrating daily progress 
- Maintaining focus during work sessions

## 💻 Tech Stack
- Frontend: Flutter
- Backend/Database: Supabase
- State Management: Riverpod
- UI Toolkit: Flutter Material Design 3
- Authentication: Supabase Auth

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login TIMESTAMP WITH TIME ZONE,
  settings JSONB DEFAULT '{}'::jsonb
);
```

### Tasks Table
```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  priority INTEGER DEFAULT 0,
  status TEXT DEFAULT 'pending',
  due_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE,
  estimated_duration INTEGER, -- in minutes
  actual_duration INTEGER, -- in minutes
  is_recurring BOOLEAN DEFAULT false,
  recurrence_pattern JSONB -- stores recurrence rules
);
```

### Focus Sessions Table
```sql
CREATE TABLE focus_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  task_id UUID REFERENCES tasks(id) ON DELETE SET NULL,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  duration INTEGER, -- in minutes
  completed BOOLEAN DEFAULT false,
  notes TEXT
);
```

### Daily Goals Table
```sql
CREATE TABLE daily_goals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  goal TEXT NOT NULL,
  completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Motivational Messages Table
```sql
CREATE TABLE motivational_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message TEXT NOT NULL,
  category TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### User Progress Table
```sql
CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  tasks_completed INTEGER DEFAULT 0,
  focus_time INTEGER DEFAULT 0, -- in minutes
  streak_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Achievements Table
```sql
CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_name TEXT,
  requirement_type TEXT NOT NULL, -- e.g., "streak", "tasks_completed", "focus_time"
  requirement_value INTEGER NOT NULL -- value needed to unlock
);
```

### User Achievements Table
```sql
CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  achievement_id UUID REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, achievement_id)
);
```

## 📁 Flutter Project Structure

```
dailyvictory/
├── android/                   # Android native code
├── ios/                      # iOS native code
├── lib/                      # Main Dart code directory
│   ├── main.dart            # Application entry point
│   ├── app.dart             # App widget configuration
│   ├── config/              # App configuration
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   ├── constants.dart
│   │   └── routes.dart      # Navigation routes
│   ├── data/                # Data layer
│   │   ├── models/          # Data models (using Map<String, dynamic>)
│   │   │   ├── task.dart
│   │   │   ├── user.dart
│   │   │   ├── focus_session.dart
│   │   │   └── daily_goal.dart
│   │   ├── repositories/    # Repository implementations
│   │   │   ├── task_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   └── focus_repository.dart
│   │   └── datasources/     # Data sources
│   │       ├── supabase/    # Supabase integration
│   │       │   ├── supabase_client.dart
│   │       │   ├── supabase_tasks.dart
│   │       │   └── supabase_auth.dart
│   │       └── local/       # Local storage
│   │           └── preferences.dart
│   ├── domain/              # Domain layer
│   │   ├── entities/        # Core business entities
│   │   └── repositories/    # Repository interfaces
│   ├── presentation/        # UI layer
│   │   ├── screens/         # App screens
│   │   │   ├── auth/        # Authentication screens
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   ├── dashboard/   # Dashboard screens
│   │   │   │   └── dashboard_screen.dart
│   │   │   ├── focus/       # Focus mode screens
│   │   │   │   ├── focus_screen.dart
│   │   │   │   └── break_screen.dart
│   │   │   ├── tasks/       # Task management screens
│   │   │   │   ├── task_list_screen.dart
│   │   │   │   └── task_detail_screen.dart
│   │   │   └── settings/    # Settings screens
│   │   │       └── settings_screen.dart
│   │   ├── widgets/         # Reusable widgets
│   │   │   ├── common/      # Common widgets
│   │   │   │   ├── app_bar.dart
│   │   │   │   └── loading_indicator.dart
│   │   │   ├── task/        # Task related widgets
│   │   │   │   ├── task_card.dart
│   │   │   │   └── task_form.dart
│   │   │   └── focus/       # Focus mode widgets
│   │   │       ├── timer_display.dart
│   │   │       └── progress_circle.dart
│   │   └── providers/       # State providers (Riverpod)
│   │       ├── auth_provider.dart
│   │       ├── task_provider.dart
│   │       └── focus_provider.dart
│   ├── utils/               # Utility functions
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── extensions/      # Extension methods
│   │       ├── string_extensions.dart
│   │       └── datetime_extensions.dart
│   └── services/            # Service implementations
│       ├── notification_service.dart
│       ├── analytics_service.dart
│       └── storage_service.dart
├── assets/                   # App assets
│   ├── images/              # Image assets
│   ├── fonts/               # Font assets
│   └── audio/               # Audio assets
├── test/                     # Test directory
│   ├── unit/                # Unit tests
│   ├── widget/              # Widget tests
│   └── integration/         # Integration tests
└── web/                      # Web-specific code
```

## 🗂️ Data Modeling Approach

DailyVictory uses a straightforward approach to data modeling with no code generation tools:

### Using Map<String, dynamic> for Data Models

All data models in the app will be handled using `Map<String, dynamic>` objects for simplicity and flexibility. This approach:

- Eliminates the need for code generation tools (no freezed, json_serializable, build_runner)
- Provides direct compatibility with Supabase JSON responses
- Enables easy serialization/deserialization

Example Task model implementation:

```dart
// in data/models/task.dart
class Task {
  // Convert Supabase response to internal model
  static Map<String, dynamic> fromSupabase(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'title': data['title'],
      'description': data['description'],
      'priority': data['priority'] ?? 0,
      'status': data['status'] ?? 'pending',
      'dueDate': data['due_date'] != null 
          ? DateTime.parse(data['due_date']) 
          : null,
      'createdAt': DateTime.parse(data['created_at']),
      'isRecurring': data['is_recurring'] ?? false,
      // Add other fields as needed
    };
  }

  // Convert to Supabase format for storage
  static Map<String, dynamic> toSupabase(Map<String, dynamic> task) {
    return {
      'title': task['title'],
      'description': task['description'],
      'priority': task['priority'],
      'status': task['status'],
      'due_date': task['dueDate']?.toIso8601String(),
      'is_recurring': task['isRecurring'],
      // Add other fields as needed
    };
  }
}
```

## 📱 App Flow

### 1️⃣ Welcome & Reminder Screen (5s Display)
When the app opens, users see:
- A reminder of their daily goal
- Remaining time to complete the goal for the day
- Time wasted if the goal hasn't been started yet

### 2️⃣ Dashboard
The main interface displays:
- Tasks for the current day
- Completed tasks with visual indicators
- Upcoming tasks for tomorrow

Users can:
- Sort tasks by priority manually
- Add new tasks through a simple input form
- View their progress at a glance

### 3️⃣ Task Execution (Focus Mode)
When a task is started:
- The app enters **Focus Mode** utilizing the **Pomodoro Technique**
  - 25-minute focus sessions
  - Short breaks between sessions
- Distractions are minimized
- A progress timer is displayed prominently

### 4️⃣ Task Completion & Reward Screen
After successfully completing a task:
- A reward screen appears celebrating the achievement
- Visual feedback reinforces positive behavior
- The user is encouraged to start another session

### 5️⃣ Motivational & Reminder System
- Daily reminders to maintain consistency
- Motivational quotes sent periodically
- Streak information to encourage continued engagement

## ✨ Core Features

### ✅ Manual Task Management
- Add, edit, and sort tasks manually
- Set tasks to repeat for habit formation
- Prioritize important items

### ⏳ Pomodoro-Based Focus Mode
- Structured time blocks for efficient work
- Automatic timing of work/break intervals
- Distraction-free interface during sessions

### 📊 Progress Tracking
- Visual representation of daily goals
- Streak monitoring for habit formation
- Historical data to view long-term progress

### 🎉 Reward System
- Celebration animations upon task completion
- Achievement badges for consistent performance
- Progress milestones to maintain motivation

### 💬 Motivational Elements
- Curated inspirational quotes
- Smart notifications to encourage action
- Positive reinforcement messaging

## 🛠️ Development Roadmap

### Phase 1: Core Functionality
- [ ] Implement basic UI components for each screen
- [ ] Build task creation and management system
- [ ] Create Pomodoro timer functionality

### Phase 2: Enhanced Features
- [ ] Add support for recurring tasks
- [ ] Implement streak tracking system
- [ ] Develop the reward and achievement system

### Phase 3: Refinement
- [ ] Optimize user experience based on feedback
- [ ] Add data visualization for progress metrics
- [ ] Implement advanced customization options

---

*This document serves as a guide for developers implementing DailyVictory, a focused productivity solution for building consistent habits and achieving daily goals.*
