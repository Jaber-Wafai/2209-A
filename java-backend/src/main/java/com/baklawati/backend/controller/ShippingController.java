// File: src/main/java/com/baklawati/backend/controller/ShippingController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.Shipping;
import com.baklawati.backend.repository.ShippingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shipping")
public class ShippingController {

    @Autowired
    private ShippingRepository shippingRepository;

    @GetMapping
    public List<Shipping> getAllShipping() {
        return shippingRepository.findAll();
    }

    @GetMapping("/{id}")
    public Shipping getShippingById(@PathVariable Long id) {
        return shippingRepository.findById(id).orElse(null);
    }

    @PostMapping
    public Shipping createShipping(@RequestBody Shipping shipping) {
        return shippingRepository.save(shipping);
    }

    @DeleteMapping("/{id}")
    public void deleteShipping(@PathVariable Long id) {
        shippingRepository.deleteById(id);
    }
}
