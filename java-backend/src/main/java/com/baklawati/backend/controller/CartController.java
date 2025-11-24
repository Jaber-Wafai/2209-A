package com.baklawati.backend.controller;

import com.baklawati.backend.models.Cart;
import com.baklawati.backend.repository.CartRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartRepository cartRepository;

    @GetMapping
    public List<Cart> getAllCartItems() {
        return cartRepository.findAll();
    }

    @PostMapping
    public Cart addCartItem(@RequestBody Cart cart) {
        return cartRepository.save(cart);
    }

    @DeleteMapping("/{id}")
    public void deleteCartItem(@PathVariable Long id) {
        cartRepository.deleteById(id);
    }
}
