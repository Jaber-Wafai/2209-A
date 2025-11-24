package com.baklawati.backend.controller;


import com.baklawati.backend.models.WalletCard;
import com.baklawati.backend.repository.WalletCardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wallet/cards")
public class WalletCardController {

    @Autowired
    private WalletCardRepository cardRepository;

    @PostMapping("/add")
    public WalletCard addCard(@RequestBody WalletCard card) {
        return cardRepository.save(card);
    }

    @GetMapping("/{userId}")
    public List<WalletCard> getCardsByUser(@PathVariable int userId) {
        return cardRepository.findByUserId(userId);
    }
}
