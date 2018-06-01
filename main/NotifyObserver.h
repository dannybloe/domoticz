#pragma once
#include <string>

enum _eNotifyType
{
	NOTIFY_LOG,             // 0
	NOTIFY_STARTUP,         // 1
	NOTIFY_SHUTDOWN,        // 2
	NOTIFY_NOTIFICATION,    // 3
	NOTIFY_BACKUP_START,    // 4
	NOTIFY_BACKUP_END,      // 5
	NOTIFY_HW_TIMEOUT,      // 6
	NOTIFY_THREAD_END,      // 7
	NOTIFY_HW_START,        // 8
	NOTIFY_HW_STOP          // 9
};

enum _eNotifyStatus
{
	NOTIFY_ERROR,   // LOG_ERROR
	NOTIFY_INFO,    // LOG_STATUS
	NOTIFY_NORM,    // LOG_NORM
	NOTIFY_TRACE,   // LOG_TRACE
};

class CNotifyObserver
{
public:
	virtual bool NotifyReceiver(const _eNotifyType type, const _eNotifyStatus status, const std::string &message) = 0;
};
