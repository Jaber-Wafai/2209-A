package com.baklawati.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "card_tokens")
public class CreditCardToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String token;
    private String last4;
    private String expiry;

    public CreditCardToken() {
    }

    public CreditCardToken(String token, String last4, String expiry) {
        this.token = token;
        this.last4 = last4;
        this.expiry = expiry;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getLast4() {
        return last4;
    }

    public void setLast4(String last4) {
        this.last4 = last4;
    }

    public String getExpiry() {
        return expiry;
    }

    public void setExpiry(String expiry) {
        this.expiry = expiry;
    }
}
