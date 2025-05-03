#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <sstream>
#include <cstdint>
#include <random>
#include <fstream>
using namespace std;

// Function to generate a random 128-bit hex string (16 bytes = 32 hex chars)
string generateRandomHexInput() {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(0, 15);
    stringstream ss;
    for (int i = 0; i < 32; ++i) {
        ss << hex << dis(gen);
    }
    return ss.str();
}

// --- SBOX and RCON omitted for brevity — assume you copy them from your existing code ---
const uint8_t sbox[256] = {
    0x63,0x7C,0x77,0x7B,0xF2,0x6B,0x6F,0xC5,0x30,0x01,0x67,0x2B,0xFE,0xD7,0xAB,0x76,
    0xCA,0x82,0xC9,0x7D,0xFA,0x59,0x47,0xF0,0xAD,0xD4,0xA2,0xAF,0x9C,0xA4,0x72,0xC0,
    0xB7,0xFD,0x93,0x26,0x36,0x3F,0xF7,0xCC,0x34,0xA5,0xE5,0xF1,0x71,0xD8,0x31,0x15,
    0x04,0xC7,0x23,0xC3,0x18,0x96,0x05,0x9A,0x07,0x12,0x80,0xE2,0xEB,0x27,0xB2,0x75,
    0x09,0x83,0x2C,0x1A,0x1B,0x6E,0x5A,0xA0,0x52,0x3B,0xD6,0xB3,0x29,0xE3,0x2F,0x84,
    0x53,0xD1,0x00,0xED,0x20,0xFC,0xB1,0x5B,0x6A,0xCB,0xBE,0x39,0x4A,0x4C,0x58,0xCF,
    0xD0,0xEF,0xAA,0xFB,0x43,0x4D,0x33,0x85,0x45,0xF9,0x02,0x7F,0x50,0x3C,0x9F,0xA8,
    0x51,0xA3,0x40,0x8F,0x92,0x9D,0x38,0xF5,0xBC,0xB6,0xDA,0x21,0x10,0xFF,0xF3,0xD2,
    0xCD,0x0C,0x13,0xEC,0x5F,0x97,0x44,0x17,0xC4,0xA7,0x7E,0x3D,0x64,0x5D,0x19,0x73,
    0x60,0x81,0x4F,0xDC,0x22,0x2A,0x90,0x88,0x46,0xEE,0xB8,0x14,0xDE,0x5E,0x0B,0xDB,
    0xE0,0x32,0x3A,0x0A,0x49,0x06,0x24,0x5C,0xC2,0xD3,0xAC,0x62,0x91,0x95,0xE4,0x79,
    0xE7,0xC8,0x37,0x6D,0x8D,0xD5,0x4E,0xA9,0x6C,0x56,0xF4,0xEA,0x65,0x7A,0xAE,0x08,
    0xBA,0x78,0x25,0x2E,0x1C,0xA6,0xB4,0xC6,0xE8,0xDD,0x74,0x1F,0x4B,0xBD,0x8B,0x8A,
    0x70,0x3E,0xB5,0x66,0x48,0x03,0xF6,0x0E,0x61,0x35,0x57,0xB9,0x86,0xC1,0x1D,0x9E,
    0xE1,0xF8,0x98,0x11,0x69,0xD9,0x8E,0x94,0x9B,0x1E,0x87,0xE9,0xCE,0x55,0x28,0xDF,
    0x8C,0xA1,0x89,0x0D,0xBF,0xE6,0x42,0x68,0x41,0x99,0x2D,0x0F,0xB0,0x54,0xBB,0x16
};

const uint8_t Rcon[10] = {0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1B,0x36};

// Galois multiplication
uint8_t gmul(uint8_t a, uint8_t b) {
    uint8_t p = 0;
    for (int i = 0; i < 8; ++i) {
        if (b & 1) p ^= a;
        bool hi_bit_set = (a & 0x80);
        a <<= 1;
        if (hi_bit_set) a ^= 0x1B;
        b >>= 1;
    }
    return p;
}

// Forward SubBytes
void subBytes(uint8_t state[4][4]) {
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            state[r][c] = sbox[state[r][c]];
        }
    }
}

// Forward ShiftRows
void shiftRows(uint8_t state[4][4]) {
    uint8_t temp;

    // Row 1: shift left by 1
    temp = state[1][0];
    state[1][0] = state[1][1];
    state[1][1] = state[1][2];
    state[1][2] = state[1][3];
    state[1][3] = temp;

    // Row 2: shift left by 2
    temp = state[2][0];
    state[2][0] = state[2][2];
    state[2][2] = temp;
    temp = state[2][1];
    state[2][1] = state[2][3];
    state[2][3] = temp;

    // Row 3: shift left by 3 (or right by 1)
    temp = state[3][3];
    state[3][3] = state[3][2];
    state[3][2] = state[3][1];
    state[3][1] = state[3][0];
    state[3][0] = temp;
}

// Forward MixColumns
void mixColumns(uint8_t state[4][4]) {
    uint8_t temp[4];
    for (int c = 0; c < 4; ++c) {
        temp[0] = gmul(state[0][c], 2) ^ gmul(state[1][c], 3) ^ state[2][c] ^ state[3][c];
        temp[1] = state[0][c] ^ gmul(state[1][c], 2) ^ gmul(state[2][c], 3) ^ state[3][c];
        temp[2] = state[0][c] ^ state[1][c] ^ gmul(state[2][c], 2) ^ gmul(state[3][c], 3);
        temp[3] = gmul(state[0][c], 3) ^ state[1][c] ^ state[2][c] ^ gmul(state[3][c], 2);
        for (int i = 0; i < 4; ++i)
            state[i][c] = temp[i];
    }
}


// AddRoundKey
void addRoundKey(uint8_t state[4][4], const uint8_t roundKey[16]) {
    for (int c = 0; c < 4; ++c)
        for (int r = 0; r < 4; ++r)
            state[r][c] ^= roundKey[c * 4 + r];
}

// Key expansion (AES-128 → 11 round keys)
void keyExpansion(const uint8_t* key, uint8_t roundKeys[11][16]) {
    for (int i = 0; i < 16; ++i)
        roundKeys[0][i] = key[i];

    for (int round = 1; round <= 10; ++round) {
        uint8_t* prev = roundKeys[round - 1];
        uint8_t* curr = roundKeys[round];

        // RotWord + SubWord
        uint8_t t[4] = {
            sbox[prev[13]],
            sbox[prev[14]],
            sbox[prev[15]],
            sbox[prev[12]]
        };

        // First column
        for (int i = 0; i < 4; ++i)
            curr[i] = prev[i] ^ t[i] ^ (i == 0 ? Rcon[round - 1] : 0);

        // Remaining columns
        for (int i = 4; i < 16; ++i)
            curr[i] = prev[i] ^ curr[i - 4];
    }
}

// Utility to parse hex string into byte array
vector<uint8_t> hexToBytes(const string& hex) {
    vector<uint8_t> bytes;
    for (size_t i = 0; i < hex.length(); i += 2)
        bytes.push_back(stoul(hex.substr(i, 2), nullptr, 16));
    return bytes;
}

// Convert 16-byte state array to 4x4 matrix
void loadState(const vector<uint8_t>& input, uint8_t state[4][4]) {
    for (int i = 0; i < 16; ++i)
        state[i % 4][i / 4] = input[i];
}

// Convert state matrix back to hex string
string stateToHex(const uint8_t state[4][4]) {
    stringstream ss;
    ss << hex << setfill('0');
    for (int c = 0; c < 4; ++c)
        for (int r = 0; r < 4; ++r)
            ss << setw(2) << static_cast<int>(state[r][c]);
    return ss.str();
}

// Full AES-128 encryption
string aesEncrypt(const string& hexInput, const string& hexKey) {
    vector<uint8_t> plaintext = hexToBytes(hexInput);
    vector<uint8_t> key = hexToBytes(hexKey);

    uint8_t roundKeys[11][16];
    keyExpansion(key.data(), roundKeys);

    uint8_t state[4][4];
    loadState(plaintext, state);

    addRoundKey(state, roundKeys[0]);

    for (int round = 1; round <= 9; ++round) {
        subBytes(state);
        shiftRows(state);
        mixColumns(state);
        addRoundKey(state, roundKeys[round]);
    }

    // Final round
    subBytes(state);
    shiftRows(state);
    addRoundKey(state, roundKeys[10]);

    return stateToHex(state);
}

/*
int main() {
    string hexInput = "00112233445566778899aabbccddeeff";
    string hexKey   = "000102030405060708090a0b0c0d0e0f";

    string ciphertext = aesEncrypt(hexInput, hexKey);
    cout << "Ciphertext: " << ciphertext << endl;

    return 0;
}
*/

int main() {
    const int N = 256;  // number of random inputs
    string hexKey = "000102030405060708090a0b0c0d0e0f";  // fixed 128-bit key

    ofstream inputFile("inputs.txt");
    ofstream cipherFile("ciphertexts.txt");

    if (!inputFile.is_open() || !cipherFile.is_open()) {
        cerr << "Error opening output files." << endl;
        return 1;
    }

    for (int i = 0; i < N; ++i) {
        string hexInput = generateRandomHexInput();
        string ciphertext = aesEncrypt(hexInput, hexKey);

        inputFile << hexInput << endl;
        cipherFile << ciphertext << endl;

        cout << "Plaintext " << i + 1 << ": " << hexInput << " => Ciphertext: " << ciphertext << endl;
    }

    inputFile.close();
    cipherFile.close();

    cout << "Completed writing " << N << " inputs and ciphertexts to files." << endl;

    return 0;
}
