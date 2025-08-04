package com.doctorclinic.controller;

import com.doctorclinic.model.Appointment;
import com.doctorclinic.model.Doctor;
import com.doctorclinic.model.User;
import com.doctorclinic.repository.AppointmentRepository;
import com.doctorclinic.repository.DoctorRepository;
import com.doctorclinic.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

@Controller
@RequestMapping("/appointments") // Base path for all appointment-related endpoints
public class AppointmentController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private DoctorRepository doctorRepo;

    @Autowired
    private AppointmentRepository appointmentRepo;

    /**
     * Displays the appointment booking form for a specific doctor.
     * Accessible at /appointments/book?doctorId={id}
     */
    @GetMapping("/book")
    public String showBookAppointmentForm(@RequestParam Long doctorId,
                                          HttpSession session,
                                          Model model,
                                          RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Security check: Only patients can book appointments
        if (loggedInUser == null || loggedInUser.getRole() != User.Role.PATIENT) {
            redirectAttributes.addFlashAttribute("error", "Please login as a patient to book an appointment.");
            return "redirect:/login";
        }

        // Fetch the doctor details
        Optional<Doctor> doctorOptional = doctorRepo.findById(doctorId);
        if (doctorOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Doctor not found.");
            return "redirect:/userDashboard"; // Redirect back if doctor doesn't exist
        }

        model.addAttribute("doctor", doctorOptional.get());
        model.addAttribute("loggedInUser", loggedInUser); // For display in header/form
        model.addAttribute("appointment", new Appointment()); // For form binding

        return "bookAppointment"; // Name of your new JSP file
    }

    /**
     * Processes the submission of the appointment booking form.
     * Accessible at /appointments/book
     */
    @PostMapping("/book")
    public String processBookAppointment(@RequestParam Long doctorId,
                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime time,
                                         HttpSession session,
                                         RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Security check: Only patients can book appointments
        if (loggedInUser == null || loggedInUser.getRole() != User.Role.PATIENT) {
            redirectAttributes.addFlashAttribute("error", "Please login as a patient to book an appointment.");
            return "redirect:/login";
        }

        // Basic Validation: Date and Time must be in the future
        if (date.isBefore(LocalDate.now()) || (date.isEqual(LocalDate.now()) && time.isBefore(LocalTime.now()))) {
            redirectAttributes.addFlashAttribute("error", "Appointment date and time must be in the future.");
            // Redirect back to the booking form for the specific doctor
            return "redirect:/appointments/book?doctorId=" + doctorId;
        }

        Optional<Doctor> doctorOptional = doctorRepo.findById(doctorId);
        if (doctorOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Doctor not found.");
            return "redirect:/userDashboard";
        }

        Doctor doctor = doctorOptional.get();

        Appointment appointment = new Appointment();
        appointment.setUser(loggedInUser);
        appointment.setDoctor(doctor);
        appointment.setDate(date);
        appointment.setTime(time);

        try {
            appointmentRepo.save(appointment);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment booked successfully!");
        } catch (Exception e) {
            e.printStackTrace(); // Log the exception for debugging
            redirectAttributes.addFlashAttribute("error", "Error booking appointment: " + e.getMessage());
            return "redirect:/appointments/book?doctorId=" + doctorId;
        }

        return "redirect:/userDashboard"; // Redirect to user dashboard to see new appointment
    }

    /**
     * Handles the cancellation of an appointment by a user.
     * This method is a POST to prevent accidental deletion via a GET request.
     * Accessible at /appointments/delete
     */
    @PostMapping("/delete")
    public String deleteAppointment(@RequestParam("appointmentId") Long appointmentId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "You must be logged in to cancel an appointment.");
            return "redirect:/login";
        }

        Optional<Appointment> appointmentOptional = appointmentRepo.findById(appointmentId);

        // Check if the appointment exists
        if (appointmentOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment not found.");
            return "redirect:/userDashboard";
        }

        Appointment appointment = appointmentOptional.get();

        // Security check: Ensure the logged-in user owns this appointment
        if (!appointment.getUser().getId().equals(loggedInUser.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "You are not authorized to cancel this appointment.");
            return "redirect:/userDashboard";
        }

        try {
            appointmentRepo.delete(appointment);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment has been successfully cancelled.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An error occurred while cancelling the appointment.");
        }

        // Redirect back to the user's dashboard to see the updated list of appointments
        return "redirect:/userDashboard";
    }
}