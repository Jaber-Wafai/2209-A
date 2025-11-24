package com.baklawati.backend;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import jakarta.annotation.PostConstruct;
import java.security.Security;

@SpringBootApplication
public class BaklawatiBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(BaklawatiBackendApplication.class, args);
    }

    // ✅ Add BouncyCastle provider at startup
    // @PostConstruct
    // public void setupSecurityProvider() {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
}
