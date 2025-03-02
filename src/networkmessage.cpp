// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "networkmessage.h"

#include "container.h"
#include "creature.h"

std::string NetworkMessage::getString(uint16_t stringLen/* = 0*/)
{
	if (stringLen == 0) {
		stringLen = get<uint16_t>();
	}

	if (!canRead(stringLen)) {
		return std::string();
	}

	char* v = reinterpret_cast<char*>(buffer) + info.position; //does not break strict aliasing
	info.position += stringLen;
	return std::string(v, stringLen);
}

Position NetworkMessage::getPosition()
{
	Position pos;
	pos.x = get<uint16_t>();
	pos.y = get<uint16_t>();
	pos.z = getByte();
	return pos;
}

void NetworkMessage::addString(const std::string& value)
{
	size_t stringLen = value.length();
	if (!canAdd(stringLen + 2)) {
		return;
	}

	add<uint16_t>(stringLen);
	memcpy(buffer + info.position, value.c_str(), stringLen);
	info.position += stringLen;
	info.length += stringLen;
}

void NetworkMessage::addDouble(double value, uint8_t precision/* = 2*/)
{
	addByte(precision);
	add<uint32_t>((value * std::pow(static_cast<float>(10), precision)) + std::numeric_limits<int32_t>::max());
}

void NetworkMessage::addBytes(const char* bytes, size_t size)
{
	if (!canAdd(size)) {
		return;
	}

	memcpy(buffer + info.position, bytes, size);
	info.position += size;
	info.length += size;
}

void NetworkMessage::addPaddingBytes(size_t n)
{
	if (!canAdd(n)) {
		return;
	}

	memset(buffer + info.position, 0x33, n);
	info.length += n;
}

void NetworkMessage::addPosition(const Position& pos)
{
	add<uint16_t>(pos.x);
	add<uint16_t>(pos.y);
	addByte(pos.z);
}

void NetworkMessage::addItem(uint16_t id, uint16_t count)
{
	const ItemType& it = Item::items[id];

	add<uint16_t>(it.clientId);

	addByte(0xFF); // MARK_UNMARKED

	if (it.stackable) {
		add<uint16_t>(count);
	} else if (it.isSplash() || it.isFluidContainer()) {
		addByte(fluidMap[count & 7]);
	}

	if (it.isAnimation) {
		addByte(0xFE); // random phase (0xFF for async)
	}
}

void NetworkMessage::addItem(const Item* item)
{
	const ItemType& it = Item::items[item->getID()];

	add<uint16_t>(it.clientId);
	addByte(0xFF); // MARK_UNMARKED

	if (it.stackable) {
		add<uint16_t>(item->getItemCount());
	} else if (it.isSplash() || it.isFluidContainer()) {
		addByte(fluidMap[item->getFluidType() & 7]);
	}

	if (it.isAnimation) {
		addByte(0xFE); // random phase (0xFF for async)
	}
}

void NetworkMessage::addItemId(uint16_t itemId)
{
	add<uint16_t>(Item::items[itemId].clientId);
}

void NetworkMessage::AddItemInformations(const Item* item)
{
	uint64_t value = item->getID();

	if (!value) {
		addByte(0x0);
	}
	else {
		addByte(0x1);

		add<uint64_t>(item->getID());

		addString(item->getName());

		const ItemType& itemInfo = Item::items[item->getID()];

		addByte(1);
		addString(item->getStrAttr(ITEM_ATTRIBUTE_SPECIAL));

		std::string itemDesc = itemInfo.description;
		addString(itemDesc);
	}
}
