package com.baklawati.backend;

import org.bouncycastle.crypto.params.X25519PrivateKeyParameters;
import org.bouncycastle.util.encoders.Base64;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.SecureRandom;

public class KeyGenerator {
    public static void main(String[] args) throws Exception {
        SecureRandom secureRandom = new SecureRandom();
        X25519PrivateKeyParameters privateKey = new X25519PrivateKeyParameters(secureRandom);
        byte[] privateBytes = privateKey.getEncoded();
        byte[] publicBytes = privateKey.generatePublicKey().getEncoded();

        Files.write(Path.of("server_x25519_private.key"), privateBytes);
        Files.write(Path.of("server_x25519_public.key"), publicBytes);

        System.out.println("✅ Server keys generated.");
    }
} 