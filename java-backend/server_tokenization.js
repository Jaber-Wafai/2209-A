const express = require('express');
const cors = require('cors');
const forge = require('node-forge');
const mysql = require('mysql2/promise');
const { v4: uuidv4 } = require('uuid');
const app = express();
const port = 3000;

// MySQL bağlantı ayarları
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'Ilgar*2023',
    database: 'digital_wallet'
};

app.use(cors());
app.use(express.json());

// Public key endpoint
app.get('/public-key', async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);

        // Son anahtar var mı?
        const [rows] = await connection.execute(
            'SELECT PublicKey FROM EncryptionKeys ORDER BY Id DESC LIMIT 1'
        );

        if (rows.length > 0) {
            await connection.end();
            return res.send({ publicKey: rows[0].PublicKey });
        }

        // Yoksa yeni oluştur
        const keypair = forge.pki.rsa.generateKeyPair(2048);
        const publicPem = forge.pki.publicKeyToPem(keypair.publicKey);
        const privatePem = forge.pki.privateKeyToPem(keypair.privateKey);

        await connection.execute(
            'INSERT INTO EncryptionKeys (PublicKey, PrivateKey) VALUES (?, ?)',
            [publicPem, privatePem]
        );

        await connection.end();
        res.send({ publicKey: publicPem });

    } catch (err) {
        console.error('MySQL error:', err);
        res.status(500).send('Database error');
    }
});

// Tokenizasyon endpoint
app.post('/submit-card', async (req, res) => {
    const { encryptedCard, encryptedKey, iv } = req.body;

    try {
        const connection = await mysql.createConnection(dbConfig);

        // Son private key alınır
        const [rows] = await connection.execute(
            'SELECT PrivateKey FROM EncryptionKeys ORDER BY Id DESC LIMIT 1'
        );

        if (rows.length === 0) {
            return res.status(400).send({ error: 'No encryption keys found' });
        }

        const privatePem = rows[0].PrivateKey;
        const privateKey = forge.pki.privateKeyFromPem(privatePem);

        // AES anahtarını çöz
        const aesKey = forge.util.decode64(privateKey.decrypt(forge.util.decode64(encryptedKey)));

        // Kart verisini çöz
        const decipher = forge.cipher.createDecipher('AES-CBC', aesKey);
        decipher.start({ iv: forge.util.decode64(iv) });
        decipher.update(forge.util.createBuffer(forge.util.decode64(encryptedCard)));
        decipher.finish();
        const decrypted = decipher.output.toString();

        const parsedCard = JSON.parse(decrypted);
        const cardNumber = parsedCard.card;
        const last4 = cardNumber.slice(-4);
        const maskedCard = "**** **** **** " + last4;

        const token = uuidv4();
        const userId = 1; // örnek kullanıcı id

        await connection.execute(
            `INSERT INTO TokenizedCards (Token, MaskedCardData, UserId) VALUES (?, ?, ?)`,
            [token, maskedCard, userId]
        );

        await connection.end();

        res.send({ message: "Kart başarıyla çözüldü, token oluşturuldu!", token });

    } catch (err) {
        console.error('Error:', err);
        res.status(500).send({ error: 'Server error', details: err.message });
    }
});

app.listen(port, () => {
    console.log(`Server çalışıyor: http://localhost:${port}`);
});
