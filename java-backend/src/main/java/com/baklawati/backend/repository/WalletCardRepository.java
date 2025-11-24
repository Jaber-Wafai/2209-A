package com.baklawati.backend.repository;


import com.baklawati.backend.models.WalletCard;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WalletCardRepository extends JpaRepository<WalletCard, Integer> {
    List<WalletCard> findByUserId(int userId);
}
