// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_SHADERS_H
#define FS_SHADERS_H

struct Shader
{
    Shader(uint8_t id, std::string name, bool premium) :
        id(id), name(std::move(name)), premium(premium) {}

    uint8_t id;
    std::string name;
    bool premium;
};

class Shaders
{
public:
    bool reload();
    bool loadFromXml();
    Shader* getShaderByID(uint8_t id);
    Shader* getShaderByName(const std::string& name);

    const std::vector<Shader>& getShaders() const {
        return shaders;
    }

private:
    std::vector<Shader> shaders;
};

#endif