// File: src/main/java/com/baklawati/backend/models/Wishlist.java

package com.baklawati.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "wishlist")
public class Wishlist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Products product;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Products getProduct() { return product; }
    public void setProduct(Products product) { this.product = product; }
}
