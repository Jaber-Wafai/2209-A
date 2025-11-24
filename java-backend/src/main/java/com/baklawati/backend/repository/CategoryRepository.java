package com.baklawati.backend.repository;

import com.baklawati.backend.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}
