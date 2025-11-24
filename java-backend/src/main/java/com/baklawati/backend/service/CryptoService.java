package com.baklawati.backend.service;

import org.bouncycastle.crypto.agreement.X25519Agreement;
import org.bouncycastle.crypto.params.X25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.X25519PublicKeyParameters;
import org.bouncycastle.crypto.params.Ed25519PublicKeyParameters;
import org.bouncycastle.crypto.signers.Ed25519Signer;
import org.bouncycastle.util.encoders.Base64;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.SecureRandom;

@Service
public class CryptoService {

    private byte[] loadServerPrivateKey() throws Exception {
        return Files.readAllBytes(Path.of("server_x25519_private.key"));
    }

    public byte[] deriveSharedAESKey(String clientPublicBase64) throws Exception {
        byte[] serverPrivateKeyBytes = loadServerPrivateKey();
        byte[] clientPubBytes = Base64.decode(clientPublicBase64);

        X25519PrivateKeyParameters serverPriv = new X25519PrivateKeyParameters(serverPrivateKeyBytes, 0);
        X25519PublicKeyParameters clientPub = new X25519PublicKeyParameters(clientPubBytes, 0);

        byte[] shared = new byte[32];
        X25519Agreement agreement = new X25519Agreement();
        agreement.init(serverPriv);
        agreement.calculateAgreement(clientPub, shared, 0);

        return shared;
    }

    public String decryptAES(String encryptedBase64, String ivBase64, byte[] aesKey) throws Exception {
        byte[] ciphertext = Base64.decode(encryptedBase64);
        byte[] iv = Base64.decode(ivBase64);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec keySpec = new SecretKeySpec(aesKey, 0, 32, "AES");
        cipher.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv));

        byte[] plain = cipher.doFinal(ciphertext);
        return new String(plain);
    }

    public boolean verifyEd25519Signature(byte[] data, String signatureBase64, String publicKeyDerBase64) throws Exception {
        byte[] signature = Base64.decode(signatureBase64);
        byte[] publicKeyDER = Base64.decode(publicKeyDerBase64);

        byte[] rawPublicKey = new byte[32];
        System.arraycopy(publicKeyDER, 12, rawPublicKey, 0, 32);

        Ed25519PublicKeyParameters pubKey = new Ed25519PublicKeyParameters(rawPublicKey, 0);
        Ed25519Signer signer = new Ed25519Signer();
        signer.init(false, pubKey);
        signer.update(data, 0, data.length);

        return signer.verifySignature(signature);
    }

 public String generateCardToken() {
    String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    SecureRandom random = new SecureRandom();
    StringBuilder token = new StringBuilder("tok_");

    for (int i = 0; i < 24; i++) {
        int index = random.nextInt(chars.length());
        token.append(chars.charAt(index));
    }

    return token.toString();
}

}
