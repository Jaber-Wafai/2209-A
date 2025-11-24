package com.baklawati.backend.repository;

import com.baklawati.backend.models.WalletUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface WalletUserRepository extends JpaRepository<WalletUser, Integer> {
    Optional<WalletUser> findByEmail(String email);
}
