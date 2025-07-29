# 🏥 Doctor Appointment Booking System (MVC + JSP)

A **Java Spring Boot** web application using **JSP** for views, designed with the **MVC (Model-View-Controller)** architecture. This application allows patients to book appointments with doctors, while administrators and doctors can manage schedules, reports, and consultations.

---

## 👨‍⚕️ Project Overview

This system provides:
- Role-based access (Admin, Doctor, Patient)
- Appointment scheduling in fixed time slots
- Doctor profile browsing
- Admin and Doctor dashboards
- Secure login/logout for users

---

## 🔑 User Roles & Access

### 👤 Admin
- Hardcoded login
- Can view all patients and their assigned doctors
- Can manage doctor data, schedules, and reports

### 🩺 Doctor
- Hardcoded login
- Can view scheduled appointments
- Upload reports/prescriptions for assigned patients

### 🧑‍💻 Patient/User
- Can register, log in, and log out
- View available doctors and book appointments
- View booking history and reports

---

## 🔧 Tech Stack

| Layer           | Technology Used                 |
|-----------------|----------------------------------|
| Backend         | Spring Boot, Spring MVC          |
| View            | JSP (Java Server Pages) + JSTL   |
| ORM/DB Access   | Spring Data JPA                  |
| Database        | MySQL                            |
| UI Styling      | Bootstrap (responsive UI)        |
| Packaging       | WAR (for JSP compatibility)      |

---

## Created and managed by Arghyadeep Singha 

