// src/main/java/com/doctorclinic/repository/DoctorRepository.java
package com.doctorclinic.repository;

import com.doctorclinic.model.Doctor;
import com.doctorclinic.model.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {

    // Method to find doctors by name and specialization (case-insensitive, partial match)
    List<Doctor> findByNameContainingIgnoreCaseAndSpecializationContainingIgnoreCase(String name, String specialization);

    // You can also add more flexible methods if needed, e.g.,
    List<Doctor> findByNameContainingIgnoreCase(String name);
    List<Doctor> findBySpecializationContainingIgnoreCase(String specialization);

    Doctor findByUser(User user); // Ensure this existing method is still here
}