# Naming Conventions

## Overview

This document defines the naming conventions used throughout the Sirajum Monir project to ensure consistency, readability, and maintainability.

---

# General Rules

- Use English for all code.
- Use meaningful and descriptive names.
- Avoid abbreviations unless they are widely accepted.
- Keep naming consistent across the project.

---

# Project Name

Sirajum Monir

---

# File Names

Use **snake_case**.

Examples:

- home_screen.dart
- quran_repository.dart
- prayer_time_service.dart
- settings_controller.dart

---

# Folder Names

Use **snake_case**.

Examples:

- features
- shared
- repositories
- services
- widgets
- models
- routes

---

# Class Names

Use **PascalCase**.

Examples:

- HomeScreen
- QuranRepository
- PrayerService
- SettingsController

---

# Widget Names

Use **PascalCase**.

Examples:

- HomeCard
- QuranTile
- PrayerTimeWidget
- CustomButton

---

# Variable Names

Use **camelCase**.

Examples:

- userName
- currentSurah
- prayerTimes
- selectedLanguage

---

# Function Names

Use **camelCase**.

Examples:

- loadQuran()
- fetchPrayerTimes()
- saveBookmark()
- changeLanguage()

---

# Constant Names

Use **camelCase** for Dart constants.

Examples:

- defaultLanguage
- maxBookmarks
- appVersion

---

# Enum Names

Use **PascalCase**.

Examples:

- ThemeModeType
- PrayerType
- LanguageType

---

# Enum Values

Use **camelCase**.

Examples:

- light
- dark
- fajr
- asr

---

# Boolean Variables

Start with:

- is
- has
- can
- should

Examples:

- isLoggedIn
- hasInternet
- canDownload
- shouldNotify

---

# Private Members

Prefix with an underscore (_).

Examples:

- _loadData()
- _repository
- _currentUser

---

# Route Names

Use lowercase with forward slashes.

Examples:

- /
- /home
- /quran
- /hadith
- /dua
- /settings

---

# Asset Names

Use **snake_case**.

Examples:

- app_logo.png
- quran_icon.svg
- splash_background.png

---

# Translation Keys

Use **snake_case**.

Examples:

- app_name
- welcome_message
- prayer_time
- settings_title

---

# Git Branch Names

Use lowercase with hyphens.

Examples:

- feature-quran
- feature-hadith
- bugfix-search
- docs-update

---

# Commit Messages

Use short and descriptive English messages.

Examples:

- Add Quran feature
- Update README
- Fix prayer calculation
- Improve UI
- Add documentation

---

## Goal

Maintain a clean, consistent, and professional codebase across the entire project.
