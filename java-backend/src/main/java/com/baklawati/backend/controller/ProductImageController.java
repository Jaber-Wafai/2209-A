// File: src/main/java/com/baklawati/backend/controller/ProductImageController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.ProductImages;
import com.baklawati.backend.repository.ProductImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/productImages")
public class ProductImageController {

    @Autowired
    private ProductImageRepository productImageRepository;

    @GetMapping
    public List<ProductImages> getAllImages() {
        return productImageRepository.findAll();
    }

    @GetMapping("/product/{productId}")
    public List<ProductImages> getImagesByProduct(@PathVariable Long productId) {
        return productImageRepository.findByProductId(productId);
    }

    @PostMapping
    public ProductImages uploadImage(@RequestBody ProductImages image) {
        return productImageRepository.save(image);
    }

    @DeleteMapping("/{id}")
    public void deleteImage(@PathVariable Long id) {
        productImageRepository.deleteById(id);
    }
}
