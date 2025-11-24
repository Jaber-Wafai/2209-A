package com.example.payment.service;

import com.example.payment.dto.EncryptedCardRequest;
import com.example.payment.entity.TokenizedCard;
import com.example.payment.repository.TokenizedCardRepository;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class CardService {

    @Autowired
    private TokenizedCardRepository tokenizedCardRepository;

    // Backend tarafında kullanılan AES anahtarı (32 byte = 256 bit)
    private static final byte[] AES_KEY = "12345678901234567890123456789012".getBytes(StandardCharsets.UTF_8);

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public String processEncryptedCard(EncryptedCardRequest request) throws Exception {
        // 1. İmza doğrula
        boolean validSignature = verifySignature(
            request.getPublicKey(),
            request.getEncryptedCard(),
            request.getSignature()
        );

        if (!validSignature) {
            return "Geçersiz imza!";
        }

        // 2. AES şifre çöz
        String decryptedJson = decryptAES(request.getEncryptedCard(), request.getIv());

        // 3. JSON'dan kart bilgilerini oku
        ObjectMapper mapper = new ObjectMapper();
        CardData cardData = mapper.readValue(decryptedJson, CardData.class);

        // 4. Token oluştur (örnek UUID kullanıyoruz)
        String token = java.util.UUID.randomUUID().toString();

        // 5. Kart bilgisini entity'e set et ve DB'ye kaydet
        TokenizedCard card = new TokenizedCard();
        card.setToken(token);
        card.setMaskedCardData(maskCard(cardData.getCard()));
        card.setUserId(1L);  // Örnek sabit userId, gerçek projede auth'dan alınmalı

        tokenizedCardRepository.save(card);

        return "Kart başarıyla kaydedildi, token: " + token;
    }

    private boolean verifySignature(String publicKeyBase64, String dataBase64, String signatureBase64) throws Exception {
        byte[] publicKeyBytes = Base64.getDecoder().decode(publicKeyBase64);
        byte[] dataBytes = Base64.getDecoder().decode(dataBase64);
        byte[] signatureBytes = Base64.getDecoder().decode(signatureBase64);

        KeyFactory keyFactory = KeyFactory.getInstance("Ed25519", "BC");
        PublicKey publicKey = keyFactory.generatePublic(new X509EncodedKeySpec(publicKeyBytes));

        Signature sig = Signature.getInstance("Ed25519", "BC");
        sig.initVerify(publicKey);
        sig.update(dataBytes);

        return sig.verify(signatureBytes);
    }

    private String decryptAES(String encryptedBase64, String ivBase64) throws Exception {
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedBase64);
        byte[] ivBytes = Base64.getDecoder().decode(ivBase64);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec secretKey = new SecretKeySpec(AES_KEY, "AES");
        IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);

        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec);
        byte[] decrypted = cipher.doFinal(encryptedBytes);

        return new String(decrypted, StandardCharsets.UTF_8);
    }

    private String maskCard(String cardNumber) {
        // İlk 6 ve son 4 dışındakileri * ile maskele
        if (cardNumber.length() < 10) return cardNumber; // güvenlik vs.

        String first6 = cardNumber.substring(0, 6);
        String last4 = cardNumber.substring(cardNumber.length() - 4);
        StringBuilder masked = new StringBuilder(first6);
        for (int i = 0; i < cardNumber.length() - 10; i++) {
            masked.append("*");
        }
        masked.append(last4);
        return masked.toString();
    }

    // Kart bilgilerini modellemek için iç sınıf
    static class CardData {
        private String card;
        private String expiry;
        private String cvv;

        // Getter ve Setter
        public String getCard() { return card; }
        public void setCard(String card) { this.card = card; }
        public String getExpiry() { return expiry; }
        public void setExpiry(String expiry) { this.expiry = expiry; }
        public String getCvv() { return cvv; }
        public void setCvv(String cvv) { this.cvv = cvv; }
    }
}
