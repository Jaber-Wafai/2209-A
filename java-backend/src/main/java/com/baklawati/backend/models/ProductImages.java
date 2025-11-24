// File: src/main/java/com/baklawati/backend/models/ProductImage.java

package com.baklawati.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "ProductImages")
public class ProductImages {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String imageUrl;
    private Boolean isPrimary;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Products product;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Boolean getIsPrimary() { return isPrimary; }
    public void setIsPrimary(Boolean isPrimary) { this.isPrimary = isPrimary; }

    public Products getProduct() { return product; }
    public void setProduct(Products product) { this.product = product; }
}
