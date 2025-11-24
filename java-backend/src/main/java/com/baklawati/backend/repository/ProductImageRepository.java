// File: src/main/java/com/baklawati/backend/repository/ProductImageRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.ProductImages;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductImageRepository extends JpaRepository<ProductImages, Long> {
    List<ProductImages> findByProductId(Long productId);
}
