package com.baklawati.backend.controller;

import com.baklawati.backend.models.WalletUser;
import com.baklawati.backend.repository.WalletUserRepository;
import com.baklawati.backend.util.Ed25519SignatureUtil;
import com.baklawati.backend.util.DilithiumSignatureUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/wallet")
public class WalletAuthController {

    @Autowired
    private WalletUserRepository walletUserRepository;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> body) {
        try {
            String email = body.get("email");
            String password = body.get("password");
            String publicKey = body.get("publicKey");
            String algorithm = body.get("algorithm");

            if (email == null || password == null || publicKey == null || algorithm == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Missing required fields"));
            }

            WalletUser user = new WalletUser();
            user.setEmail(email);
            user.setPassword(password); // ⚠️ Use hashing in production
            user.setPublicKey(publicKey);
            user.setAlgorithm(algorithm);
            user.setCreatedAt(LocalDateTime.now());

            walletUserRepository.save(user);

            return ResponseEntity.ok(Map.of("message", "Registration successful"));

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(Map.of("error", "Error: " + e.getMessage()));
        }
    }

   @PostMapping("/login")
public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body) {
    try {
        String email = body.get("email");
        String password = body.get("password");
        String data = body.get("data");
        String signature = body.get("signature");
        String algorithm = body.get("algorithm");

        Map<String, Object> response = new HashMap<>();

        Optional<WalletUser> userOpt = walletUserRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            response.put("error", "User not found");
            return ResponseEntity.status(404).body(response);
        }

        WalletUser user = userOpt.get();

        if (!user.getPassword().equals(password)) {
            response.put("error", "Incorrect password");
            return ResponseEntity.status(401).body(response);
        }

        if (!user.getAlgorithm().equalsIgnoreCase(algorithm)) {
            response.put("error", "Algorithm mismatch. You registered with " + user.getAlgorithm());
            return ResponseEntity.status(400).body(response);
        }

        System.out.println("📥 Verifying login for " + email);
        System.out.println("🔑 Algorithm: " + algorithm);
        System.out.println("📄 Data: " + data);

        String shortSig = signature.length() > 30 ? signature.substring(0, 30) : signature;
        String shortPub = user.getPublicKey().length() > 30 ? user.getPublicKey().substring(0, 30) : user.getPublicKey();

        System.out.println("🔏 Signature (start): " + shortSig);
        System.out.println("🔐 PublicKey (start): " + shortPub);

        boolean isValid = switch (algorithm.toLowerCase()) {
            case "dilithium" -> DilithiumSignatureUtil.verifySignature(data, signature, user.getPublicKey());
            default -> Ed25519SignatureUtil.verifySignature(data, signature, user.getPublicKey());
        };

        if (!isValid) {
            response.put("error", "Signature verification failed");
            return ResponseEntity.status(401).body(response);
        }

        response.put("message", "Login successful");
        response.put("userId", user.getId());
        return ResponseEntity.ok(response);

    } catch (Exception e) {
        return ResponseEntity.internalServerError().body(Map.of("error", "Error: " + e.getMessage()));
    }
}

}
