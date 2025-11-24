// File: src/main/java/com/baklawati/backend/models/UserActivityLog.java

package com.baklawati.backend.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_activity_log")
public class UserActivityLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;
    private String action;
    private LocalDateTime timestamp;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
