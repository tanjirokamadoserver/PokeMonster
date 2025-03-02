// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_GLOBALEVENT_H_B3FB9B848EA3474B9AFC326873947E3C
#define FS_GLOBALEVENT_H_B3FB9B848EA3474B9AFC326873947E3C
#include "baseevents.h"

#include "const.h"

enum GlobalEvent_t {
	GLOBALEVENT_NONE,
	GLOBALEVENT_TIMER,

	GLOBALEVENT_HOLDERS,
	GLOBALEVENT_STARTUP,
	GLOBALEVENT_SHUTDOWN,
	GLOBALEVENT_RECORD,
};

class GlobalEvent;
using GlobalEvent_ptr = std::unique_ptr<GlobalEvent>;
using GlobalEventMap = std::map<std::string, GlobalEvent>;

class GlobalEvents final : public BaseEvents
{
	public:
		GlobalEvents();
		~GlobalEvents();

		// non-copyable
		GlobalEvents(const GlobalEvents&) = delete;
		GlobalEvents& operator=(const GlobalEvents&) = delete;

		void startup() const;
		void createHolders(Item* pokeball) const;

		void timer();
		void think();
		void execute(GlobalEvent_t type) const;

		GlobalEventMap getEventMap(GlobalEvent_t type);
		static void clearMap(GlobalEventMap& map, bool fromLua);
		void clear(bool fromLua) override final;

		bool registerLuaEvent(Event* event);
		
	private:
		std::string getScriptBaseName() const override {
			return "globalevents";
		}
		// void clear() override;

		Event_ptr getEvent(const std::string& nodeName) override;
		bool registerEvent(Event_ptr event, const pugi::xml_node& node) override;

		LuaScriptInterface& getScriptInterface() override {
			return scriptInterface;
		}
		LuaScriptInterface scriptInterface;

		GlobalEventMap thinkMap, serverMap, timerMap;
		int32_t thinkEventId = 0, timerEventId = 0;
};

class GlobalEvent final : public Event
{
	public:
		explicit GlobalEvent(LuaScriptInterface* interface);

		bool configureEvent(const pugi::xml_node& node) override;

		bool executeRecord(uint32_t current, uint32_t old);
		bool executeEvent() const;
		void createHolder(Item* pokeball) const;

		GlobalEvent_t getEventType() const {
			return eventType;
		}

		void setEventType(GlobalEvent_t type) {
			eventType = type;
		}
		const std::string& getName() const {
			return name;
		}

		void setName(std::string eventName) {
			name = eventName;
		}

		uint32_t getInterval() const {
			return interval;
		}

		void setInterval(uint32_t eventInterval) {
			interval |= eventInterval;
		}

		int64_t getNextExecution() const {
			return nextExecution;
		}
		void setNextExecution(int64_t time) {
			nextExecution = time;
		}

	private:
		GlobalEvent_t eventType = GLOBALEVENT_NONE;

		std::string getScriptEventName() const override;

		std::string name;
		int64_t nextExecution = 0;
		uint32_t interval = 0;
};

#endif