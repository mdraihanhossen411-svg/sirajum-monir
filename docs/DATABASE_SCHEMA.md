# Database Schema

## Overview

This document defines the local database structure for the Sirajum Monir application.

The app is designed to work offline first.

---

# Tables

## Bookmarks

Stores bookmarked items.

Fields

- id
- item_type
- item_id
- title
- created_at

Example

- Quran Verse
- Hadith
- Dua

---

## Notes

Stores user notes.

Fields

- id
- item_type
- item_id
- note
- created_at
- updated_at

---

## Recent History

Stores recently opened content.

Fields

- id
- item_type
- item_id
- last_opened

---

## Settings

Stores user preferences.

Fields

- language
- theme
- font_size
- arabic_font
- translation
- tafsir
- notifications

---

## Downloads

Stores downloaded offline resources.

Fields

- id
- module
- version
- downloaded_at

---

## Future Tables

- Reading Progress
- Daily Goal
- Prayer Logs
- Tasbih History
- Favorites

---

## Storage Strategy

Offline-first architecture.

The database will synchronize only when online services are introduced.

---

Last Updated

v0.1.0
