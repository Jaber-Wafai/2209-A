package com.baklawati.backend.util;

import java.security.*;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class Ed25519SignatureUtil {

    public static boolean verifySignature(String data, String base64Signature, String base64PublicKey) throws Exception {
        byte[] publicKeyBytes = Base64.getDecoder().decode(base64PublicKey);
        byte[] signatureBytes = Base64.getDecoder().decode(base64Signature);
        byte[] message = data.getBytes();

        KeyFactory kf = KeyFactory.getInstance("Ed25519");
        PublicKey pubKey = kf.generatePublic(new X509EncodedKeySpec(publicKeyBytes));

        Signature verifier = Signature.getInstance("Ed25519");
        verifier.initVerify(pubKey);
        verifier.update(message);

        return verifier.verify(signatureBytes);
    }
}
