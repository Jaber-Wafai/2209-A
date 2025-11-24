// File: src/main/java/com/baklawati/backend/models/Shipping.java

package com.baklawati.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "shipping")
public class Shipping {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String address;
    private String city;
    private String state;
    private String postalCode;
    private String country;

    @OneToOne
    @JoinColumn(name = "order_id")
    private Order order;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
}
