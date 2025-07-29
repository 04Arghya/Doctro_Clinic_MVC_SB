package com.doctorclinic.controller;

import com.doctorclinic.model.Appointment;
import com.doctorclinic.model.Doctor;
import com.doctorclinic.model.User;
import com.doctorclinic.repository.AppointmentRepository;
import com.doctorclinic.repository.DoctorRepository;
import com.doctorclinic.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*; // Ensure this is imported

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private DoctorRepository doctorRepo;

    @Autowired
    private AppointmentRepository appointmentRepo;

    // 🏠 Home page
    @GetMapping("/")
    public String showHome() {
        return "index";
    }

    // 🧑‍⚕️ Signup GET
    @GetMapping("/signup")
    public String signupForm() {
        return "signup";
    }

    // 🧑‍⚕️ Signup POST
    @PostMapping("/signup")
    public String processSignup(@ModelAttribute User user, Model model) {
        User existing = userRepo.findByEmail(user.getEmail());
        if (existing != null) {
            model.addAttribute("error", "Email already registered.");
            return "signup";
        }
        user.setRole(User.Role.PATIENT); // Default role for signup
        userRepo.save(user);
        return "redirect:/login";
    }

    // 🔐 Login GET
    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    // 🔐 Login POST
    @PostMapping("/login") // <--- YOU WERE MISSING THIS ANNOTATION!
    public String processLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session,
                               Model model) {

        User user = userRepo.findByEmail(email);

        if (user == null || !user.getPassword().equals(password)) {
            model.addAttribute("error", "Invalid credentials.");
            return "login";
        }

        session.setAttribute("loggedInUser", user);

        if (user.getRole() == User.Role.ADMIN) {
            return "redirect:/admin/dashboard"; // Redirect to AdminController
        } else if (user.getRole() == User.Role.DOCTOR) {
            Doctor doctor = doctorRepo.findByUser(user);
            if (doctor == null) {
                model.addAttribute("error", "Doctor profile not found for this user. Please contact admin.");
                session.invalidate();
                return "login";
            }
            return "redirect:/doctorDashboard";
        } else { // PATIENT
            return "redirect:/userDashboard";
        }
    }

    // 👨‍⚕️ Doctor Dashboard
    @GetMapping("/doctorDashboard")
    public String showDoctorDashboard(HttpSession session, Model model) {
        User doctorUser = (User) session.getAttribute("loggedInUser");

        if (doctorUser == null || doctorUser.getRole() != User.Role.DOCTOR) {
            return "redirect:/login";
        }

        Doctor doctor = doctorRepo.findByUser(doctorUser);
        if (doctor == null) {
            model.addAttribute("error", "Doctor profile not found for your account.");
            session.invalidate();
            return "login";
        }

        List<Appointment> appointments = appointmentRepo.findByDoctor(doctor);

        Set<User> assignedPatientsSet = appointments.stream()
                .map(Appointment::getUser)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        model.addAttribute("appointments", appointments);
        model.addAttribute("assignedPatients", new ArrayList<>(assignedPatientsSet));
        model.addAttribute("doctorName", doctor.getName());
        model.addAttribute("loggedInUser", doctorUser);

        return "doctorDashboard";
    }

    // 👤 User Dashboard - NOW WITH SEARCH CAPABILITY
    @GetMapping("/userDashboard")
    public String showUserDashboard(@RequestParam(value = "searchName", required = false) String searchName,
                                  @RequestParam(value = "searchSpecialization", required = false) String searchSpecialization,
                                  HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null || loggedInUser.getRole() != User.Role.PATIENT) {
            return "redirect:/login";
        }

        List<Doctor> doctors;

        // Determine if a search query was provided
        boolean isSearching = (searchName != null && !searchName.trim().isEmpty()) ||
                              (searchSpecialization != null && !searchSpecialization.trim().isEmpty());

        if (isSearching) {
            // If only one field is provided, ensure the other is treated as empty for 'ContainingIgnoreCase'
            String nameQuery = (searchName != null) ? searchName : "";
            String specializationQuery = (searchSpecialization != null) ? searchSpecialization : "";

            doctors = doctorRepo.findByNameContainingIgnoreCaseAndSpecializationContainingIgnoreCase(nameQuery, specializationQuery);
        } else {
            // If no search query, show all doctors
            doctors = doctorRepo.findAll();
        }

        List<Appointment> appointments = appointmentRepo.findByUser(loggedInUser);

        model.addAttribute("doctors", doctors);
        model.addAttribute("appointments", appointments);
        model.addAttribute("loggedInUser", loggedInUser);
        model.addAttribute("searchName", searchName); // Pass back search terms to pre-fill form
        model.addAttribute("searchSpecialization", searchSpecialization); // Pass back search terms to pre-fill form

        return "userDashboard";
    }

    // 🚪 Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}