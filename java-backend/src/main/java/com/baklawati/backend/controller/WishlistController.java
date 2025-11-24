// File: src/main/java/com/baklawati/backend/controller/WishlistController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.Wishlist;
import com.baklawati.backend.repository.WishlistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wishlist")
public class WishlistController {

    @Autowired
    private WishlistRepository wishlistRepository;

    @GetMapping
    public List<Wishlist> getAllWishlistItems() {
        return wishlistRepository.findAll();
    }

    @GetMapping("/user/{userId}")
    public List<Wishlist> getWishlistByUser(@PathVariable Long userId) {
        return wishlistRepository.findByUserId(userId);
    }

    @PostMapping
    public Wishlist addToWishlist(@RequestBody Wishlist wishlist) {
        return wishlistRepository.save(wishlist);
    }

    @DeleteMapping("/{id}")
    public void removeFromWishlist(@PathVariable Long id) {
        wishlistRepository.deleteById(id);
    }
}
