package com.baklawati.backend.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import org.json.JSONObject;

public class DilithiumSignatureUtil {

    public static boolean verifySignature(String data, String base64Signature, String base64PublicKey) {
        try {
            JSONObject json = new JSONObject();
            json.put("data", data);
            json.put("signature", base64Signature);
            json.put("publicKey", base64PublicKey);

            URL url = new URL("http://127.0.0.1:8000/verify");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = json.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            return responseCode == 200;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}