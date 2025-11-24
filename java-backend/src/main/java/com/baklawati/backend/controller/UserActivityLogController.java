// File: src/main/java/com/baklawati/backend/controller/UserActivityLogController.java

package com.baklawati.backend.controller;

import com.baklawati.backend.models.UserActivityLog;
import com.baklawati.backend.repository.UserActivityLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/activity-log")
public class UserActivityLogController {

    @Autowired
    private UserActivityLogRepository userActivityLogRepository;

    @GetMapping
    public List<UserActivityLog> getAllLogs() {
        return userActivityLogRepository.findAll();
    }

    @GetMapping("/user/{userId}")
    public List<UserActivityLog> getLogsByUser(@PathVariable Long userId) {
        return userActivityLogRepository.findByUserId(userId);
    }

    @PostMapping
    public UserActivityLog addLog(@RequestBody UserActivityLog log) {
        log.setTimestamp(LocalDateTime.now());
        return userActivityLogRepository.save(log);
    }
}
