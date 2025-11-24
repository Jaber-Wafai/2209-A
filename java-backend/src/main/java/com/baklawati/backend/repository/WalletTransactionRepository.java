package com.baklawati.backend.repository;




import com.baklawati.backend.models.WalletTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WalletTransactionRepository extends JpaRepository<WalletTransaction, Integer> {
    List<WalletTransaction> findByUserId(int userId);
}
