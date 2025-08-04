package com.doctorclinic.repository;

import com.doctorclinic.model.User;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> { // Changed Integer to Long
    User findByEmail(String email);

    List<User> findByRole(User.Role role); // Changed String to User.Role

    List<User> findByName(String name); // for reverse lookup

    User findByEmailAndPassword(String email, String password);
}