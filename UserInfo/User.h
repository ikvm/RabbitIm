#ifndef USER_H
#define USER_H

#include <QObject>
#include <QSharedPointer>
#include "UserInfo.h"
#include "Message/ManageMessage.h"

#undef GetMessage

/**
 * @defgroup RABBITIM_INTERFACE_USER 用户接口类模块  
 * @ingroup RABBITIM_INTERFACE_MANAGEUSER
 * @brief 用户类模块  
 */

/**
 * @class CUser
 * @ingroup RABBITIM_INTERFACE_USER RABBITIM_INTERFACE
 * @brief 用户类  
 * 包括用户信息和用户消息,由 CManageUser 管理  
 * @see CManageUser
 * @see CUserInfo
 * @see CManageMessage
 */
class CUser : public QObject
{
    Q_OBJECT
public:
    explicit CUser(QObject *parent = 0);
    virtual ~CUser();

    /**
     * @brief 得到用户信息对象  
     * @return 返回 CUserInfo 对象  
     */
    QSharedPointer<CUserInfo> GetInfo();
    /**
     * @brief 得到用户的消息管理对象  
     * @return 返回 CManageMessage 对象  
     */
    QSharedPointer<CManageMessage> GetMessage();

signals:

public slots:
private:
    QSharedPointer<CUserInfo> m_Info;
    QSharedPointer<CManageMessage> m_Message;
};

#endif // USER_H
