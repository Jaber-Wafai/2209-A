package com.baklawati.backend.service;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Base64;
import java.util.Map;

@Service
public class DilithiumService {

    private final String baseUrl = "http://localhost:8000";
    private final RestTemplate restTemplate = new RestTemplate();

    public Map<String, String> generateKeyPair() {
        ResponseEntity<Map> response = restTemplate.postForEntity(baseUrl + "/generate-key", null, Map.class);
        return response.getBody();
    }

    public String sign(String message, String privateKey) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        String body = String.format("""
            {
                "message": "%s",
                "privateKey": "%s"
            }
        """, message, privateKey);
        HttpEntity<String> req = new HttpEntity<>(body, headers);
        ResponseEntity<Map> res = restTemplate.postForEntity(baseUrl + "/sign", req, Map.class);
        return (String) res.getBody().get("signature");
    }

    public boolean verify(String message, String signature, String publicKey) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        String body = String.format("""
            {
                "message": "%s",
                "signature": "%s",
                "publicKey": "%s"
            }
        """, message, signature, publicKey);
        HttpEntity<String> req = new HttpEntity<>(body, headers);
        ResponseEntity<Map> res = restTemplate.postForEntity(baseUrl + "/verify", req, Map.class);
        return (Boolean) res.getBody().get("valid");
    }
}
