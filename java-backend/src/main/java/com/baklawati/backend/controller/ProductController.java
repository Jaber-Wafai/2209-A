package com.baklawati.backend.controller;

import com.baklawati.backend.models.Products;
import com.baklawati.backend.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    // GET all products
    @GetMapping
    public List<Products> getAllProducts() {
        return productRepository.findAll();
    }

    // GET product by ID
    @GetMapping("/{id}")
    public ResponseEntity<Products> getProductById(@PathVariable Long id) {
        Optional<Products> product = productRepository.findById(id);
        return product.map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }

    // POST add new product
    @PostMapping
    public Products addProduct(@RequestBody Products product) {
        return productRepository.save(product);
    }

    // PUT update product by ID
    @PutMapping("/{id}")
    public ResponseEntity<Products> updateProduct(@PathVariable Long id, @RequestBody Products updatedProduct) {
        return productRepository.findById(id)
                .map(product -> {
                    product.setName(updatedProduct.getName());
                    product.setDescription(updatedProduct.getDescription());
                    product.setPrice(updatedProduct.getPrice());
                    product.setVatRate(updatedProduct.getVatRate());
                    product.setTrendyolPrice(updatedProduct.getTrendyolPrice());
                    product.setTrendyolUrl(updatedProduct.getTrendyolUrl());
                    product.setShippingTime(updatedProduct.getShippingTime());
                    product.setStock(updatedProduct.getStock());
                    product.setCategory(updatedProduct.getCategory());
                    return ResponseEntity.ok(productRepository.save(product));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE product by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
