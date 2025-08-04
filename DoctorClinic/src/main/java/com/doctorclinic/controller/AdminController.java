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
import org.springframework.transaction.annotation.Transactional;

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

        List<Appointment> allAppointments = appointmentRepo.findAll();
        model.addAttribute("allAppointments", allAppointments);
        
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
        return "addDoctor"; // JSP name for the add doctor form view
    }

    /**
     * Processes the submission of the "Add Doctor" form.
     */
    @PostMapping("/addDoctor")
    public String processAddDoctor(@ModelAttribute Doctor doctor, // Binds doctor fields (name, specialization, experience)
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

        User existingUser = userRepo.findByEmail(userEmail);
        if (existingUser != null) {
            redirectAttributes.addFlashAttribute("error", "A user with this email already exists.");
            return "redirect:/admin/addDoctor";
        }

        User newUser = new User();
        newUser.setName(doctor.getName());
        newUser.setEmail(userEmail);
        newUser.setPassword(userPassword);
        newUser.setRole(User.Role.DOCTOR);
        userRepo.save(newUser);

        doctor.setUser(newUser);
        doctorRepo.save(doctor);

        redirectAttributes.addFlashAttribute("successMessage", "Doctor '" + doctor.getName() + "' and associated user added successfully!");
        return "redirect:/admin/dashboard";
    }

    /**
     * Handles the deletion of a doctor.
     * This method is transactional to ensure all related data is deleted together.
     */
    @Transactional
    @PostMapping("/deleteDoctor")
    public String deleteDoctor(@RequestParam("id") Long doctorId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        User adminUser = (User) session.getAttribute("loggedInUser");
        if (adminUser == null || adminUser.getRole() != User.Role.ADMIN) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Only admins can delete doctors.");
            return "redirect:/login";
        }

        Optional<Doctor> doctorOptional = doctorRepo.findById(doctorId);
        if (doctorOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: Doctor not found with ID " + doctorId);
            return "redirect:/admin/dashboard";
        }

        Doctor doctor = doctorOptional.get();
        User doctorUser = doctor.getUser();

        try {
            List<Appointment> appointments = appointmentRepo.findByDoctor(doctor);
            appointmentRepo.deleteAll(appointments);

            doctorRepo.delete(doctor);

            if (doctorUser != null) {
                userRepo.delete(doctorUser);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Doctor '" + doctor.getName() + "' and all associated data have been deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An error occurred while deleting the doctor: " + e.getMessage());
        }

        return "redirect:/admin/dashboard";
    }

    /**
     * Deletes an appointment by its ID.
     * This method is called from the Admin Dashboard.
     */
    @PostMapping("/deleteAppointment")
    public String deleteAppointment(@RequestParam("id") Long appointmentId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {

        User adminUser = (User) session.getAttribute("loggedInUser");
        // Security check: Ensure only ADMIN users can perform this action
        if (adminUser == null || adminUser.getRole() != User.Role.ADMIN) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Please login as admin.");
            return "redirect:/login";
        }

        try {
            appointmentRepo.deleteById(appointmentId);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment with ID " + appointmentId + " has been deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An error occurred while deleting the appointment: " + e.getMessage());
        }

        return "redirect:/admin/dashboard";
    }
}