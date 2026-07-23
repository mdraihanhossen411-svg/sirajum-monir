# State Management

## Overview

This document defines the state management strategy for the Sirajum Monir application.

---

# State Management Solution

The application uses **Riverpod** as the primary state management solution.

---

# Why Riverpod?

- Simple and scalable
- Compile-time safety
- Better dependency injection
- Easy testing
- Excellent performance
- Clean architecture friendly

---

# State Categories

## Global State

Shared across the application.

Examples

- Theme
- Language
- Authentication
- Settings

---

## Feature State

Specific to individual features.

Examples

- Quran
- Hadith
- Dua
- Prayer Time
- Qibla
- Tasbih

---

## Local UI State

Temporary screen state.

Examples

- Loading
- Selected Tab
- Search Text
- Dialog State

---

# Provider Types

- Provider
- StateProvider
- FutureProvider
- StreamProvider
- NotifierProvider
- AsyncNotifierProvider

---

# Folder Structure

lib/

state/

providers/

controllers/

services/

repositories/

---

# Data Flow

UI

↓

Provider

↓

Repository

↓

Local Database / API

↓

Repository

↓

Provider

↓

UI

---

# Best Practices

- Keep providers small.
- Avoid business logic inside widgets.
- Use repositories for data access.
- Keep UI clean.
- Separate feature providers.

---

# Error Handling

All errors should be handled inside providers and repositories.

The UI should only display the appropriate state.

---

# Future Improvements

- Offline synchronization
- Background refresh
- Cached providers

---

## Goal

Maintain a clean, scalable, testable, and high-performance state management architecture across the application.
