# DentiPlus API

FastAPI backend for [DentiPlus](../README.md). It stores users, consultations and appointments in MySQL, relays the consultation chat to the AI service, and records diagnoses on the Ethereum blockchain.

## Features

- **Authentication**: JWT tokens (OAuth2 password flow), bcrypt password hashing, doctor and patient roles
- **Consultations**: chat with the AI assistant, diagnosis with the 3 most likely conditions and their confidence, dentist review (validate or ask for a follow-up), AI-improved dentist notes
- **Appointments**: booking, rescheduling, cancellation, unavailable time slots
- **Blockchain**: each reviewed diagnosis is written to a smart contract in the background; the integrity check compares the database with the contract
- **Users**: profile, password change, profile photo upload

The interactive documentation of the 34 endpoints is at `/docs` once the server runs.

## Requirements

- Python 3.9+ (tested with 3.12)
- MySQL
- Optional: a Google account for the AI service (Colab), and an Ethereum Sepolia account for the blockchain

## Setup

1. Create the database:

   ```sql
   CREATE DATABASE dentiplus;
   ```

   The tables are created automatically when the API starts.

2. Copy the settings template and fill it in:

   ```bash
   cp .env_template .env
   ```

3. Install the dependencies in a virtual environment:

   ```bash
   python -m venv .venv
   .venv\Scripts\activate          # Windows
   source .venv/bin/activate       # Linux/macOS
   pip install -r requirements.txt
   ```

4. Start the API on port 5001, the port the app expects:

   ```bash
   uvicorn main:app --reload --port 5001
   ```

   Then open http://localhost:5001/docs.

## Settings (`.env`)

| Variable | Needed for | Description |
|---|---|---|
| `DATABASE_URL` | everything | e.g. `mysql+mysqlconnector://root:password@localhost/dentiplus` |
| `SECRET_KEY` | everything | Key that signs the JWT tokens: 64 hex characters, generate one with `openssl rand -hex 32` |
| `ALGORITHM`, `ACCESS_TOKEN_EXPIRE_MINUTES`, `BCRYPT_SALT_ROUNDS` | | Token algorithm (HS256), token lifetime (20 min), bcrypt cost (12) |
| `ROLE_DOCTOR`, `ROLE_PATIENT`, `TOKEN_URL` | | Role names and login route; keep the defaults |
| `GIST_ID` | AI chat | ID of the GitHub Gist where the Colab notebook publishes its address (see below) |
| `BLOCKCHAIN_URL` | blockchain | Sepolia RPC URL, e.g. from Alchemy or Infura |
| `DIAGNOSIS_CONTRACT_ADDRESS` | blockchain | Address of the deployed diagnosis contract |
| `ACCOUNT`, `PRIVATE_KEY` | blockchain | Sepolia account that pays for the transactions. Use a test account only, and never commit `.env` |

`BASE_URL` and `STORAGE_CONTRACT_ADDRESS` in the template are not used anymore.

Without the AI and blockchain settings, the API still starts: authentication, profiles, consultations and appointments work. The chat returns an error, and reviewed diagnoses are saved in the database but not written to the blockchain (the write runs in the background after the dentist's action).

## AI Service

The language model runs in Google Colab, because it needs a GPU:

- **Model**: Qwen2.5-7B-Instruct, 4-bit GGUF, run with `llama-cpp-python`
- **Server**: a FastAPI app inside the notebook (`/chat`, `/process_chat`, `/improve_note`, `/diagnose-en`, `/diagnose-fr`…), exposed on the internet with ngrok
- **Address**: ngrok gives a new URL at each start, so the notebook writes it into a GitHub Gist, and the API reads it from there at startup

To run it:

1. Create a secret GitHub Gist with a file named `ngrok_url.txt`, and put its ID in `GIST_ID`
2. Open `colab_remote_backend_notebooks/FastAPI_Remote_LLM_backend_prod.ipynb` in Colab with a GPU runtime
3. Fill in your ngrok token, the Gist ID and a GitHub token allowed to edit Gists, then run all cells
4. Start (or restart) the API so it reads the new address

The two `experimental` notebooks are earlier versions.

## Blockchain

Diagnoses are stored in a Solidity contract on the Sepolia test network: the 3 conditions with their confidence, the dentist's diagnosis, the patient and dentist IDs and the date.

1. Deploy `blockchain_smart_contracts/SmartContract_Diagnosis_V3.sol` (the latest version) with [Remix](https://remix.ethereum.org) on Sepolia
2. Put its address in `DIAGNOSIS_CONTRACT_ADDRESS`, and a Sepolia RPC URL, account and private key in the other settings

The other `.sol` files are earlier versions.

## Project Structure

```
main.py                         App, CORS and routers
models.py                       Database tables (SQLAlchemy)
controllers/                    Routes: auth, users, patients, doctors, consultations, blockchain
services/                       Calls to the AI service and to the smart contract
schemas/                        Request and response models (Pydantic)
dependencies/                   Settings, database session, authentication
dev_scripts/                    Create the tables without starting the API: python -m dev_scripts.db_create
colab_remote_backend_notebooks/ AI service notebooks
blockchain_smart_contracts/     Solidity contracts
```
