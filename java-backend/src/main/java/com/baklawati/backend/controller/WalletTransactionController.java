package com.baklawati.backend.controller;

import com.baklawati.backend.models.WalletTransaction;
import com.baklawati.backend.repository.WalletTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/wallet")
public class WalletTransactionController {

    @Autowired
    private WalletTransactionRepository transactionRepository;

    @PostMapping("/add-money")
    public WalletTransaction addMoney(@RequestBody WalletTransaction tx) {
        tx.setType("ADD");
        tx.setSignature(null); // Signature will be added later
        return transactionRepository.save(tx);
    }
}
