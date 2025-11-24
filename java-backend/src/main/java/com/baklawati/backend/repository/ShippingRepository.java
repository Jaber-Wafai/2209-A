// File: src/main/java/com/baklawati/backend/repository/ShippingRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.Shipping;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ShippingRepository extends JpaRepository<Shipping, Long> {
}
