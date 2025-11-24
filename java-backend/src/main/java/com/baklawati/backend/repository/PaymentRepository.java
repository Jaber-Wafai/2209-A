// File: src/main/java/com/baklawati/backend/repository/PaymentRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
}
