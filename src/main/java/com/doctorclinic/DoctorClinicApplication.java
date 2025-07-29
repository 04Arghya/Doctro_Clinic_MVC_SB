package com.doctorclinic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication(scanBasePackages = "com.doctorclinic") 
public class DoctorClinicApplication {
    public static void main(String[] args) {
        SpringApplication.run(DoctorClinicApplication.class, args);
    }
}
