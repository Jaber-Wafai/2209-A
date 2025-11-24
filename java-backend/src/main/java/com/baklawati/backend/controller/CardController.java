package com.baklawati.backend.controller;

import com.baklawati.backend.models.CreditCardToken;
import com.baklawati.backend.repository.CreditCardTokenRepository;
import com.baklawati.backend.service.CryptoService;
import com.baklawati.backend.util.DilithiumSignatureUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.bouncycastle.crypto.params.X25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.X25519PublicKeyParameters;
import org.bouncycastle.util.encoders.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/cards")
public class CardController {

    @Autowired
    private CryptoService cryptoService;

    @Autowired
    private CreditCardTokenRepository creditCardTokenRepository;

    @PostMapping("/request-aes-key")
    public Map<String, String> sendServerPublicKey(@RequestBody Map<String, String> request) throws Exception {
        byte[] serverPrivateKey = Files.readAllBytes(Path.of("server_x25519_private.key"));
        X25519PrivateKeyParameters serverPriv = new X25519PrivateKeyParameters(serverPrivateKey, 0);
        X25519PublicKeyParameters serverPub = serverPriv.generatePublicKey();
        String serverPublicBase64 = Base64.toBase64String(serverPub.getEncoded());
        return Map.of("serverPublicKey", serverPublicBase64);
    }

    @PostMapping("/submit-card-dilithium")
    public String receiveDilithiumCard(@RequestBody Map<String, String> payload) {
        try {
            String encryptedCard = payload.get("encryptedCard");
            String ivBase64 = payload.get("iv");
            String signature = payload.get("signature");
            String publicKey = payload.get("publicKey");
            String clientX25519 = payload.get("clientPublicKey");

            if (encryptedCard == null || ivBase64 == null || signature == null || publicKey == null || clientX25519 == null) {
                return "❌ Missing required fields.";
            }

            // Step 1: Derive AES key from X25519
            byte[] aesKey = cryptoService.deriveSharedAESKey(clientX25519);

            // Step 2: Decrypt card JSON
            String decryptedCardJson = cryptoService.decryptAES(encryptedCard, ivBase64, aesKey);
            System.out.println("🔓 Decrypted Card JSON: " + decryptedCardJson);

            // Step 3: Verify Dilithium Signature
            boolean isValid = DilithiumSignatureUtil.verifySignature(encryptedCard, signature, publicKey);
            if (!isValid) {
                return "❌ Dilithium signature verification failed!";
            }

            // Step 4: Parse card data
            Map<String, String> cardData = new ObjectMapper().readValue(decryptedCardJson, Map.class);
            String cardNumber = cardData.get("card");
            String expiry = cardData.get("expiry");

            if (cardNumber == null || cardNumber.length() < 1) {
                return "❌ Invalid card number.";
            }

            String last4;
            try {
                last4 = cardNumber.substring(Math.max(0, cardNumber.length() - 4));
            } catch (Exception e) {
                last4 = cardNumber;
            }

            // Step 5: Save tokenized card
            String token = UUID.randomUUID().toString();
            CreditCardToken tokenRecord = new CreditCardToken(token, last4, expiry);
            creditCardTokenRepository.save(tokenRecord);

            return "✅ Dilithium card token stored: " + token;

        } catch (Exception e) {
            e.printStackTrace();
            return "❌ Error while processing Dilithium card: " + e.getMessage();
        }
    }
}
