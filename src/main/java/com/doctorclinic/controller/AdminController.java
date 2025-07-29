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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin") // Base path for all admin-related endpoints
public class AdminController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private DoctorRepository doctorRepo;

    @Autowired
    private AppointmentRepository appointmentRepo;

    /**
     * Displays the Admin Dashboard.
     * Accessible at /admin/dashboard
     * Shows a summary of appointments and a list of registered doctors.
     */
    @GetMapping("/dashboard")
    public String showAdminDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User adminUser = (User) session.getAttribute("loggedInUser");
        // Security check: Ensure only ADMIN users can access this dashboard
        if (adminUser == null || adminUser.getRole() != User.Role.ADMIN) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Please login as admin.");
            return "redirect:/login";
        }

        // Fetch all appointments to display in the summary
        List<Appointment> appointments = appointmentRepo.findAll();
        Map<User, List<String>> patientDoctorMap = new HashMap<>();

        // Group appointments by patient to show which doctors each patient has appointments with
        for (Appointment appointment : appointments) {
            User patient = appointment.getUser();
            Doctor doctor = appointment.getDoctor();

            if (patient != null && doctor != null) {
                patientDoctorMap
                        .computeIfAbsent(patient, k -> new ArrayList<>())
                        .add(doctor.getName());
            }
        }

        model.addAttribute("patientDoctorMap", patientDoctorMap);
        model.addAttribute("loggedInUser", adminUser);
        model.addAttribute("doctors", doctorRepo.findAll()); // Add all doctors to display on the admin dashboard
        return "adminDashboard"; // JSP name for the admin dashboard view
    }

    /**
     * Displays the form for an admin to add a new doctor profile.
     * Accessible at /admin/addDoctor
     */
    @GetMapping("/addDoctor")
    public String showAddDoctorForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User adminUser = (User) session.getAttribute("loggedInUser");
        // Security check: Ensure only ADMIN users can access this form
        if (adminUser == null || adminUser.getRole() != User.Role.ADMIN) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Only admins can add doctors.");
            return "redirect:/login";
        }

        model.addAttribute("doctor", new Doctor()); // Create a new Doctor object for form binding
        model.addAttribute("loggedInUser", adminUser); // For display in header/JSP
        // We no longer need to pass 'unassignedDoctorUsers' as role is set automatically
        return "addDoctor"; // JSP name for the add doctor form view
    }

    /**
     * Processes the submission of the "Add Doctor" form, handling manual photo URL entry
     * and automatic user creation with DOCTOR role.
     * Accessible at /admin/addDoctor (POST request)
     */
    @PostMapping("/addDoctor")
    public String processAddDoctor(@ModelAttribute Doctor doctor, // Binds doctor fields (name, specialization, experience, photoUrl)
                                   @RequestParam("userEmail") String userEmail, // Captures email for new user
                                   @RequestParam("userPassword") String userPassword, // Captures password for new user
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {

        User adminUser = (User) session.getAttribute("loggedInUser");
        // Security check: Ensure only ADMIN users can perform this action
        if (adminUser == null || adminUser.getRole() != User.Role.ADMIN) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Only admins can add doctors.");
            return "redirect:/login";
        }

        // --- 1. Create User with DOCTOR role automatically ---
        User existingUser = userRepo.findByEmail(userEmail);
        if (existingUser != null) {
            redirectAttributes.addFlashAttribute("error", "A user with this email already exists.");
            return "redirect:/admin/addDoctor"; // Redirect back to form with error
        }

        User newUser = new User();
        newUser.setName(doctor.getName()); // Use doctor's name for user's name
        newUser.setEmail(userEmail);
        newUser.setPassword(userPassword);
        newUser.setRole(User.Role.DOCTOR); // Automatically set role to DOCTOR
        userRepo.save(newUser);

        // --- 2. Link Doctor to the newly created User and Save Doctor ---
        // The 'photoUrl' field is now directly bound from the form to the 'doctor' object via @ModelAttribute
        doctor.setUser(newUser); // Link the newly created Doctor profile to the new User
        doctorRepo.save(doctor); // Save the new Doctor profile

        redirectAttributes.addFlashAttribute("successMessage", "Doctor '" + doctor.getName() + "' and associated user added successfully!");
        return "redirect:/admin/dashboard"; // Redirect back to the admin dashboard after successful addition
    }
}