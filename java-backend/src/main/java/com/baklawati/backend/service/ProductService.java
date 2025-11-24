package com.baklawati.backend.service;

import   com.baklawati.backend.models.Products;
import com.baklawati.backend.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepo;

    public List<Products> getAllProducts() {
        return productRepo.findAll();
    }

    public Products getProductById(Long id) {
        return productRepo.findById(id).orElse(null);
    }

    public Products createProduct(Products product) {
        return productRepo.save(product);
    }

    public Products updateProduct(Long id, Products updatedProduct) {
        Products product = productRepo.findById(id).orElse(null);
        if (product != null) {
            product.setName(updatedProduct.getName());
            product.setDescription(updatedProduct.getDescription());
            product.setPrice(updatedProduct.getPrice());
            product.setStock(updatedProduct.getStock());
            product.setShippingTime(updatedProduct.getShippingTime());
            product.setTrendyolPrice(updatedProduct.getTrendyolPrice());
            product.setTrendyolUrl(updatedProduct.getTrendyolUrl());
            product.setVatRate(updatedProduct.getVatRate());
            product.setCategory(updatedProduct.getCategory());
            return productRepo.save(product);
        }
        return null;
    }

    public void deleteProduct(Long id) {
        productRepo.deleteById(id);
    }
}
