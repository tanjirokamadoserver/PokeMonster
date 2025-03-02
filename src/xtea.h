// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef TFS_XTEA_H
#define TFS_XTEA_H

namespace xtea {

using key = std::array<uint32_t, 4>;

void encrypt(uint8_t* data, size_t length, const key& k);
void decrypt(uint8_t* data, size_t length, const key& k);

} // namespace xtea

#endif // TFS_XTEA_H
