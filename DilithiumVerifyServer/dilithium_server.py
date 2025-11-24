from fastapi import FastAPI
from pydantic import BaseModel
import base64
import oqs
import uvicorn

app = FastAPI()

# =======================
# 🔐 DILITHIUM SIGNATURE
# =======================

class VerifyRequest(BaseModel):
    data: str
    signature: str
    publicKey: str

@app.post("/verify")
async def verify_signature(req: VerifyRequest):
    try:
        sig_alg = oqs.Signature("Dilithium3")
        public_key = base64.b64decode(req.publicKey)
        signature = base64.b64decode(req.signature)
        message = req.data.encode()

        is_valid = sig_alg.verify(message, signature, public_key)
        return {"valid": is_valid}
    except Exception as e:
        return {"valid": False, "error": str(e)}




# ======================
# 🚀 Run the API Server
# ======================
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
