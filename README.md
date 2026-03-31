# Amanah: Your Daily Islamic Companion

**Amanah** (meaning "trust" or "responsibility" in Arabic) is a comprehensive mobile application designed to support Muslims in their everyday spiritual journey through an integrated, calming, and user-centered digital experience.

## 🌟 Unique Value Proposition
Unlike many existing Islamic apps, Amanah distinguishes itself through:
**Emotional Intelligence:** A unique system providing mood-based Surah recommendations to offer spiritual guidance tailored to your emotional state.
**Mindful Design:** A calm, distraction-free interface that promotes intentional engagement rather than addictive scrolling.
**Holistic Growth:** Integrated goal setting and nightly reflection check-ins to help build consistent Islamic habits.

## 🚀 Key Features
**Core Worship:** Real-time prayer timings with countdowns, a digital Quran with audio recitation, and an accurate Qibla compass.
**Spiritual Growth:** Habit tracking for prayers and Quran reading with data-driven insights into religious habits.
**Learning & Knowledge:** Structured Seerah (Prophetic Biography) chapters, Islamic articles, and an Islamic calendar.
**Scholar Connection:** A safe space to request guidance from verified Islamic scholars.

## 🛠️ Tech Stack
**Frontend:** **Flutter** (for a cross-platform, aesthetically pleasing mobile experience)
**Backend:** **Django** (handling core logic, user authentication, and API management)
**Database:** **MongoDB** (storing flexible, document-based data for Quranic content and user logs)

## 🏗️ Architecture
[cite_start]The project utilizes a layered architecture to maintain a "Privacy-First" design.
1.  **Mobile App (Flutter):** Presentation layer focusing on accessibility and modern UI.
2.  **API Layer (Django):** Manages location-based services and notification logic.
3.  **Data Layer (MongoDB):** Securely handles sensitive personal and location data.

## 📋 Installation

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/Nihaal-Durrani/Amanah-Your_Islamic_Companion.git]
    ```
2.  **Backend Setup (Django):**
    ```bash
    cd backend
    pip install -r requirements.txt
    python manage.py migrate
    python manage.py runserver
    ```
3.  **Frontend Setup (Flutter):**
    ```bash
    cd frontend
    flutter pub get
    flutter run
    ```
