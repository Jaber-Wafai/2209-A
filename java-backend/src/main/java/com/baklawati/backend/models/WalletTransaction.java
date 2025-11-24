package com.baklawati.backend.models;



import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "wallet_transaction")
public class WalletTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id")
    private int userId;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private double amount;

    @Column(name = "to_user_id")
    private Integer toUserId;

    @Column(name = "timestamp")
    private LocalDateTime timestamp = LocalDateTime.now();

    @Column(name = "signature")
    private String signature;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Integer getToUserId() { return toUserId; }
    public void setToUserId(Integer toUserId) { this.toUserId = toUserId; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }

    public String getSignature() { return signature; }
    public void setSignature(String signature) { this.signature = signature; }
}
