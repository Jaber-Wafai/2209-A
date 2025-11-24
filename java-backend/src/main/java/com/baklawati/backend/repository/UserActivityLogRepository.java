// File: src/main/java/com/baklawati/backend/repository/UserActivityLogRepository.java

package com.baklawati.backend.repository;

import com.baklawati.backend.models.UserActivityLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserActivityLogRepository extends JpaRepository<UserActivityLog, Long> {
    List<UserActivityLog> findByUserId(Long userId);
}
