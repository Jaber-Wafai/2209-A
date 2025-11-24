package com.baklawati.backend.repository;

import com.baklawati.backend.models.Cart;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CartRepository extends JpaRepository<Cart, Long> {
}
