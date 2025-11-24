package com.baklawati.backend.repository;

import  com.baklawati.backend.models.Products;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Products, Long> {
}
