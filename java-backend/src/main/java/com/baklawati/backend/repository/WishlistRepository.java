// File: src/main/java/com/baklawati/backend/repository/WishlistRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.Wishlist;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WishlistRepository extends JpaRepository<Wishlist, Long> {
    List<Wishlist> findByUserId(Long userId);
}
