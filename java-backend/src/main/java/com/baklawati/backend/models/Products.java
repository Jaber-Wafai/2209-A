// File: Product.java

package com.baklawati.backend.models;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "Products")
public class Products{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private double price;
    private int stock;
    private String shippingTime;
    private double trendyolPrice;
    private String trendyolUrl;
    private double vatRate;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<ProductImages> productImages;

    // GETTERS AND SETTERS
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getShippingTime() { return shippingTime; }
    public void setShippingTime(String shippingTime) { this.shippingTime = shippingTime; }

    public double getTrendyolPrice() { return trendyolPrice; }
    public void setTrendyolPrice(double trendyolPrice) { this.trendyolPrice = trendyolPrice; }

    public String getTrendyolUrl() { return trendyolUrl; }
    public void setTrendyolUrl(String trendyolUrl) { this.trendyolUrl = trendyolUrl; }

    public double getVatRate() { return vatRate; }
    public void setVatRate(double vatRate) { this.vatRate = vatRate; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public List<ProductImages> getProductImages() { return productImages; }
    public void setProductImages(List<ProductImages> productImages) { this.productImages = productImages; }
}
