package com.baklawati.backend.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "wallet_card")
public class WalletCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id", nullable = false)
    private int userId;

    @Column(name = "card_holder_name", nullable = false)
    private String cardHolderName;

    @Column(name = "card_number", nullable = false)
    private String cardNumber;

    @Column(name = "expiry_date", nullable = false)
    private String expiryDate;

    @Column(name = "cvv")
    private String cvv;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCardHolderName() { return cardHolderName; }
    public void setCardHolderName(String name) { this.cardHolderName = name; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String number) { this.cardNumber = number; }

    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String date) { this.expiryDate = date; }

    public String getCvv() { return cvv; }
    public void setCvv(String cvv) { this.cvv = cvv; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
