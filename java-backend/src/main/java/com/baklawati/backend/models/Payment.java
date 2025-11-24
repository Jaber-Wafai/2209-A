// File: src/main/java/com/baklawati/backend/models/Payment.java

package com.baklawati.backend.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "payments")
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private double amount;

    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentDate;

    private String paymentMethod;
    private String status;

    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
}
