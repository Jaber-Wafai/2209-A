// File: src/main/java/com/baklawati/backend/controller/CouponController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.Coupon;
import com.baklawati.backend.repository.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/coupons")
public class CouponController {

    @Autowired
    private CouponRepository couponRepository;

    @GetMapping
    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }

    @GetMapping("/{code}")
    public Optional<Coupon> getCouponByCode(@PathVariable String code) {
        return couponRepository.findByCode(code);
    }

    @PostMapping
    public Coupon createCoupon(@RequestBody Coupon coupon) {
        return couponRepository.save(coupon);
    }

    @DeleteMapping("/{id}")
    public void deleteCoupon(@PathVariable Long id) {
        couponRepository.deleteById(id);
    }
}
