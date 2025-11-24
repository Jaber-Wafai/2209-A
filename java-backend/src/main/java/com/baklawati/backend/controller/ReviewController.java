// File: src/main/java/com/baklawati/backend/controller/ReviewController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.Review;
import com.baklawati.backend.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepository;

    @GetMapping
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    @GetMapping("/product/{productId}")
    public List<Review> getReviewsByProduct(@PathVariable Long productId) {
        return reviewRepository.findByProductId(productId);
    }

    @PostMapping
    public Review addReview(@RequestBody Review review) {
        return reviewRepository.save(review);
    }

    @DeleteMapping("/{id}")
    public void deleteReview(@PathVariable Long id) {
        reviewRepository.deleteById(id);
    }
}
