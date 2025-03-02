// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "xtea.h"

#include <array>
#include <assert.h>

namespace xtea {

namespace {

constexpr uint32_t delta = 0x9E3779B9;

template<size_t BLOCK_SIZE>
void XTEA_encrypt(uint8_t data[BLOCK_SIZE * 8], const key& k)
{
    alignas(16) uint32_t left[BLOCK_SIZE], right[BLOCK_SIZE];
    for (auto i = 0u, j = 0u; i < BLOCK_SIZE; i += 1u, j += 8u) {
        left[i] = data[j] | data[j+1] << 8u | data[j+2] << 16u | data[j+3] << 24u;
        right[i] = data[j+4] | data[j+5] << 8u | data[j+6] << 16u | data[j+7] << 24u;
    }

    uint32_t sum = 0u;
    for (auto i = 0u; i < 32; ++i) {
        for (auto j = 0u; j < BLOCK_SIZE; ++j) {
            left[j] += (((right[j] << 4) ^ (right[j] >> 5)) + right[j]) ^ (sum + k[sum & 3]);
        }
        sum += delta;
        for (auto j = 0u; j < BLOCK_SIZE; ++j) {
            right[j] += (((left[j] << 4) ^ (left[j] >> 5)) + left[j]) ^ (sum + k[(sum >> 11) & 3]);
        }
    }

    for (auto i = 0u, j = 0u; i < BLOCK_SIZE; i += 1u, j += 8u) {
        data[j] = static_cast<uint8_t>(left[i]);
        data[j+1] = static_cast<uint8_t>(left[i] >> 8u);
        data[j+2] = static_cast<uint8_t>(left[i] >> 16u);
        data[j+3] = static_cast<uint8_t>(left[i] >> 24u);
        data[j+4] = static_cast<uint8_t>(right[i]);
        data[j+5] = static_cast<uint8_t>(right[i] >> 8u);
        data[j+6] = static_cast<uint8_t>(right[i] >> 16u);
        data[j+7] = static_cast<uint8_t>(right[i] >> 24u);
    }
}

template<size_t BLOCK_SIZE>
void XTEA_decrypt(uint8_t data[BLOCK_SIZE * 8], const key& k)
{
    alignas(16) uint32_t left[BLOCK_SIZE], right[BLOCK_SIZE];
    for (auto i = 0u, j = 0u; i < BLOCK_SIZE; i += 1u, j += 8u) {
        left[i] = data[j] | data[j+1] << 8u | data[j+2] << 16u | data[j+3] << 24u;
        right[i] = data[j+4] | data[j+5] << 8u | data[j+6] << 16u | data[j+7] << 24u;
    }

    uint32_t sum = delta << 5;
    for (auto i = 0u; i < 32; ++i) {
        for (auto j = 0u; j < BLOCK_SIZE; ++j) {
            right[j] -= (((left[j] << 4) ^ (left[j] >> 5)) + left[j]) ^ (sum + k[(sum >> 11) & 3]);
        }
        sum -= delta;
        for (auto j = 0u; j < BLOCK_SIZE; ++j) {
            left[j] -= (((right[j] << 4) ^ (right[j] >> 5)) + right[j]) ^ (sum + k[(sum) & 3]);
        }
    }

    for (auto i = 0u, j = 0u; i < BLOCK_SIZE; i += 1u, j += 8u) {
        data[j] = static_cast<uint8_t>(left[i]);
        data[j+1] = static_cast<uint8_t>(left[i] >> 8u);
        data[j+2] = static_cast<uint8_t>(left[i] >> 16u);
        data[j+3] = static_cast<uint8_t>(left[i] >> 24u);
        data[j+4] = static_cast<uint8_t>(right[i]);
        data[j+5] = static_cast<uint8_t>(right[i] >> 8u);
        data[j+6] = static_cast<uint8_t>(right[i] >> 16u);
        data[j+7] = static_cast<uint8_t>(right[i] >> 24u);
    }
}

constexpr auto InitialBlockSize =
#if defined(__AVX512F__)
      128u;
#elif defined(__AVX__)
      32u;
#elif defined(__SSE__) || defined(__ARM_FEATURE_SIMD32)
      8u;
#elif defined(__x86_64__)
      2u;
#else
      1u;
#endif

template<bool Encrypt, size_t BlockSize>
struct XTEA {
    static constexpr auto step = BlockSize * 8u;

    void operator()(uint8_t* input, size_t length, const key& k) const {
        const auto blocks = (length & ~(step - 1));
        for (auto i = 0u; i < blocks; i += step) {
            if (Encrypt) {
                XTEA_encrypt<BlockSize>(input + i, k);
            } else {
                XTEA_decrypt<BlockSize>(input + i, k);
            }
        }
        input += blocks;
        length -= blocks;

        if (BlockSize != 1) {
            XTEA<Encrypt, (BlockSize + 1u) / 2u>()(input, length, k);
        }
    }
};

constexpr auto encrypt_v = XTEA<true, InitialBlockSize>();
constexpr auto decrypt_v = XTEA<false, InitialBlockSize>();

} // anonymous namespace

void encrypt(uint8_t* data, size_t length, const key& k) { encrypt_v(data, length, k); }
void decrypt(uint8_t* data, size_t length, const key& k) { decrypt_v(data, length, k); }

} // namespace xtea
