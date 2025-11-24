// File: src/main/java/com/baklawati/backend/repository/CouponRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CouponRepository extends JpaRepository<Coupon, Long> {
    Optional<Coupon> findByCode(String code);
}
