
#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <cmath>
#include <chrono>  // Include the chrono library
#include "aes_key_reversal.h"
#include "aes_round_reversal.h"
using namespace std;

// Simulated SubBytes+ShiftRows operation on zero vector (placeholder)
string knownValueAfterShiftRowsSubBytes() {
    // Simulate AES SubBytes + ShiftRows on all-zero input
    return "63636363636363636363636363636363"; // Example AES output for 0...0
}


// Simulated SubBytes+ShiftRows operation on zero vector (placeholder)
string knownValueAfterMixColumnShiftRowsSubBytes() {
    // Simulate AES SubBytes + ShiftRows + Mix Column on all-zero input
    return "63636363636363636363636363636363"; // Example AES output for 0...0
} 


// Simulated AES encryption (placeholder) for demonstration
string observedLastRoundFirstCiphertext() {
    string input;
    cout << "Enter observed AES last round ciphertext with scan cells set on 1101(or press Enter to use default): ";
    getline(cin, input);
    if (input.empty()) {
        return "479f1aafdc6a1a8a5479a15f0e0bbd55"; // Default simulated value
    } else {
        return input;
    }
}

// Simulated AES encryption (placeholder) for demonstration
string observedLastRoundSecondCiphertext() {
    string input;
    cout << "Enter observed AES last round ciphertext with scan cells set on 1100(or press Enter to use default): ";
    getline(cin, input);
    if (input.empty()) {
        return "fc7d2b6bcb119dc4930ea9d0897aafeb"; // Default simulated value
    } else {
        return input;
    }
}

// Read AES ciphertexts from a file
vector<vector<string>> readAESCiphertextsFromFile(const string& filename) {
    vector<vector<string>> aesCiphertexts;
    ifstream infile(filename);
    string line;

    while (getline(infile, line)) {
        vector<string> cycleData;
        stringstream ss(line);
        string value;
        while (ss >> value) {
            cycleData.push_back(value);
        }

        if (cycleData.size() == 15) {
            aesCiphertexts.push_back(cycleData);
        } else {
            cerr << "Warning: Each line should contain exactly 15 ciphertexts." << endl;
        }
    }

    infile.close();
    return aesCiphertexts;
}

// Algorithm 2: Calculate number of clock cycles after which ciphertext changes (δ)
vector<int> calD(const vector<vector<string>>& aesCiphertexts) {
    vector<int> delta(aesCiphertexts.size(), 1);

    for (int i = 0; i < aesCiphertexts.size(); ++i) {
        for (int j = 1; j < 14; ++j) {
            if (aesCiphertexts[i][j - 1] == aesCiphertexts[i][j]) {
                delta[i]++;
            } else {    
                break;
            }
        }
    }

    return delta;
}

// Algorithm 1: Identify round counter scan cells
vector<int> identifyRoundCounterScanCells(const vector<vector<string>>& aesCiphertexts) {
    vector<int> delta = calD(aesCiphertexts);
    vector<int> counterScanCells(4, -1); // Initialize with -1 (not found)

    for (int i = 0; i < delta.size(); ++i) {
        for (int k = 0; k < 4; ++k) {
            if (delta[i] == (14 - static_cast<int>(pow(2, k)))) {
                counterScanCells[k] = i;
                break;
            }
        }
    }

    return counterScanCells;
}

// Algorithm 4: AES Last Round Encryption Key Retrieval
string retrieveAESLastRoundKey(const vector<int>& counterScanCells) {
    string testVector(128, '0'); // 128-bit test vector initialized with zeros
    if (counterScanCells[0] != -1) testVector[counterScanCells[0]] = '1';
    if (counterScanCells[1] != -1) testVector[counterScanCells[1]] = '1';
    if (counterScanCells[3] != -1) testVector[counterScanCells[3]] = '1';

    // Simulated scan shift and observation
    string aesLastCipher = observedLastRoundFirstCiphertext();
    string knownValue = knownValueAfterShiftRowsSubBytes();

    // XOR two hex strings
    string aesRoundKey = "";
    for (size_t i = 0; i < knownValue.length(); ++i) {
        char x = knownValue[i];
        char y = aesLastCipher[i];
        int xor_val = stoi(string(1, x), nullptr, 16) ^ stoi(string(1, y), nullptr, 16);
        aesRoundKey += "0123456789ABCDEF"[xor_val];
    }

    return aesRoundKey;
}

string retrieveAESSecondLastRoundKey(string aesLastSecondCipher, string aesLastRoundKey) {

    string P1_ency = "";
    for (size_t i = 0; i < aesLastSecondCipher.length(); ++i) {
        char x = aesLastSecondCipher[i];
        char y = aesLastRoundKey[i];
        int xor_val = stoi(string(1, x), nullptr, 16) ^ stoi(string(1, y), nullptr, 16);
        P1_ency += "0123456789ABCDEF"[xor_val];
    }

    return P1_ency;
}

int main() {
    auto start = chrono::high_resolution_clock::now();
    string filename;
    cout << "Enter filename containing AES ciphertexts (or press Enter to use default 'ciphertext_256.txt'): ";
    getline(cin, filename);
    if (filename.empty()) {
        filename = "state_files/AES-256_ciphertexts_256.txt";
    }
    vector<vector<string>> aesCiphertexts = readAESCiphertextsFromFile(filename);

    if (aesCiphertexts.empty()) {
        cerr << "No data found in the input file or file is malformed." << endl;
        return 1;
    }

    vector<int> counterCells = identifyRoundCounterScanCells(aesCiphertexts);

    cout << "Identified Round Counter Scan Cells:" << endl;
    for (int idx : counterCells) {
        cout << idx << " ";
    }
    cout << endl;

    string aesRoundKey = retrieveAESLastRoundKey(counterCells);
    cout << "Retrieved AES Last Round Key: " << aesRoundKey << endl;

    string second_observed_ciphertext = observedLastRoundSecondCiphertext();
    string previous_state = inverseRoundWithAddRoundKey(second_observed_ciphertext,aesRoundKey );
    
    std::cout << "Previous state: " << previous_state << std::endl;
    string known_second_value = knownValueAfterMixColumnShiftRowsSubBytes();
    
    string aesSecondLastRoundKey = retrieveAESSecondLastRoundKey(previous_state, known_second_value);
    
    //int halfLen = aesSecondLastRoundKey.length() / 2;

    string Final_key = aesRoundKey + aesSecondLastRoundKey;
    //std::cout << "AES Final key: " << Final_key << std::endl;
    std::string originalKey = reverseAESRound10Key(Final_key);
    std::cout << "Recovered AES key: " << originalKey << std::endl;
    auto stop = chrono::high_resolution_clock::now();

    // Calculate the duration in microseconds
    auto duration = chrono::duration_cast<chrono::microseconds>(stop - start);
    cout << "Execution time (including IO delay): " << duration.count() << " microseconds" << endl;
    
    
    return 0;
}
