package com.baklawati.backend.controller;

import com.baklawati.backend.models.OrderItem;
import com.baklawati.backend.repository.OrderItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order-items")
public class OrderItemController {

    @Autowired
    private OrderItemRepository orderItemRepository;

    @GetMapping
    public List<OrderItem> getAllOrderItems() {
        return orderItemRepository.findAll();
    }

    @PostMapping
    public OrderItem createOrderItem(@RequestBody OrderItem orderItem) {
        return orderItemRepository.save(orderItem);
    }

    @GetMapping("/{id}")
    public OrderItem getOrderItemById(@PathVariable Long id) {
        return orderItemRepository.findById(id).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteOrderItem(@PathVariable Long id) {
        orderItemRepository.deleteById(id);
    }
}
