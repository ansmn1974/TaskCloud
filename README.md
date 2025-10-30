# TaskCloud - Cross-Platform To-Do List Application

TaskCloud is a modern, cross-platform to-do list application built with Flutter for the frontend and Django REST Framework for the backend.

## Project Structure

```
TaskCloud/
├── frontend/           # Flutter mobile/web application
├── backend/           # Django REST Framework API
└── README.md         # This file
```

## About TaskCloud

TaskCloud provides a seamless task management experience across all platforms. Users can create, organize, and track their tasks with real-time synchronization.

**Website**: [ibn-nabil.com](https://ibn-nabil.com)

## Features

- Cross-platform compatibility (iOS, Android, Web)
- Real-time task synchronization
- User authentication and authorization
- Task categories and priorities
- Due date reminders
- Offline support with sync when online
- Clean, intuitive user interface

## Technology Stack

### Frontend (Flutter)
- Flutter SDK
- Provider/Riverpod for state management
- HTTP package for API communication
- Shared Preferences for local storage
- Material Design 3

### Backend (Django REST Framework)
- Django 4.x
- Django REST Framework
- PostgreSQL database
- JWT authentication
- Docker containerization
- Comprehensive API documentation

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Python 3.9+
- PostgreSQL
- Git

### Quick Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/TaskCloud.git
cd TaskCloud
```

2. Setup Backend:
```bash
cd backend
# Follow instructions in backend/README.md
```

3. Setup Frontend:
```bash
cd frontend
# Follow instructions in frontend/README.md
```

## Development Workflow

This project follows Test-Driven Development (TDD) principles:
1. Write tests first
2. Implement minimal code to pass tests
3. Refactor while keeping tests green
4. Repeat

## Project Status

🚧 **In Development** - This project is currently being built following best practices and TDD methodology.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

**Website**: [ibn-nabil.com](https://ibn-nabil.com)

---

Built with ❤️ using Flutter and Django REST Framework