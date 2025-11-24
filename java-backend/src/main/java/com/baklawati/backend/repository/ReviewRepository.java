// File: src/main/java/com/baklawati/backend/repository/ReviewRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.Review;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByProductId(Long productId);
}
