package com.doctorclinic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.doctorclinic.model.Appointment;
import com.doctorclinic.model.Doctor;
import com.doctorclinic.model.User;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctor(Doctor doctor);  // to get all appointments for a doctor

	

	List<Appointment> findByUser(User loggedInUser);
}

