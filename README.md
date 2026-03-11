# 🌸 Weekly Planner API

A full-stack **Laravel application** with **REST API and JWT Authentication** for managing personal tasks in a weekly planner.

This project demonstrates secure API authentication, protected routes, and a frontend interface that consumes the API.

---

## ✨ Features

🔐 **JWT Authentication**

* Register
* Login
* Logout
* Token-based API access

📋 **Task Management**

* Create tasks
* View tasks
* Update tasks (including checklist done)
* Delete tasks

🖥 **Frontend Interface**

* Login page
* Register page
* Weekly planner dashboard
* Checklist UI for task completion

---

## 🛠 Tech Stack

| Technology   | Usage              |
| ------------ | ------------------ |
| **Laravel**  | Backend Framework  |
| **JWT Auth** | Authentication     |
| **MySQL**    | Database           |
| **Blade**    | Frontend UI        |
| **REST API** | Data communication |

---

## 📡 API Endpoints

### Authentication

| Method | Endpoint        | Description             |
| ------ | --------------- | ----------------------- |
| POST   | `/api/register` | Register new user       |
| POST   | `/api/login`    | Login and get JWT token |
| POST   | `/api/logout`   | Logout user             |
| POST   | `/api/refresh`  | Refresh JWT token       |
| GET    | `/api/me`       | Get authenticated user  |

---

### Tasks Resource

| Method | Endpoint          | Description     |
| ------ | ----------------- | --------------- |
| GET    | `/api/tasks`      | Get all tasks   |
| POST   | `/api/tasks`      | Create new task |
| GET    | `/api/tasks/{id}` | Get task detail |
| PUT    | `/api/tasks/{id}` | Update task     |
| DELETE | `/api/tasks/{id}` | Delete task     |

All task endpoints are **protected with JWT middleware**.

---

## 🔑 Authentication Example

### Login

```json
POST /api/login
{
  "email": "user@email.com",
  "password": "password"
}
```

Response:

```json
{
  "access_token": "jwt_token_here",
  "token_type": "bearer",
  "expires_in": 3600
}
```

Use token in request headers:

```
Authorization: Bearer YOUR_TOKEN
```

---

## 🚀 Installation

Clone the repository:

```
git clone https://github.com/dollette05/weekly_planner.git
```

Go to project directory:

```
cd weekly_planner
```

Install dependencies:

```
composer install
```

Copy environment file:

```
cp .env.example .env
```

Generate application key:

```
php artisan key:generate
```

Generate JWT secret:

```
php artisan jwt:secret
```

Run migration:

```
php artisan migrate
```

Start server:

```
php artisan serve
```

---

## 🎥 Demonstration

Video Demonstration:
*(Insert your video link here)*

---

## 📂 Repository

GitHub Repository:
https://github.com/dollette05/weekly_planner

---

## 👩‍💻 Author

Developed by **Jennifer Alexandra**
Laravel REST API Project with JWT Authentication
