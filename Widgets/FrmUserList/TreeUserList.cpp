#include "TreeUserList.h"
#include "../../Global.h"

CTreeUserList::CTreeUserList(QWidget *parent) :
    QTreeView(parent)
{
    this->setContextMenuPolicy(Qt::CustomContextMenu);
}

void CTreeUserList::mousePressEvent(QMouseEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mousePressEvent");
    m_MousePressTime = QTime::currentTime();
    QTreeView::mousePressEvent(event);
}

void CTreeUserList::mouseReleaseEvent(QMouseEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mouseReleaseEvent");
#ifdef ANDROID
    QTime cur = QTime::currentTime();
    int sec = m_MousePressTime.secsTo(cur);
    LOG_MODEL_DEBUG("Roster", "m_MousePressTime:%s;currentTime:%s;sect:%d",
                    qPrintable(m_MousePressTime.toString("hh:mm:ss.zzz")),
                    qPrintable(cur.toString("hh:mm:ss.zzz")),
                    sec);
    if(sec >= 2)
    {
        emit customContextMenuRequested(QCursor::pos());
        return;
    }
#endif
    QTreeView::mouseReleaseEvent(event);
}

void CTreeUserList::contextMenuEvent(QContextMenuEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mouseReleaseEvent");
    QTreeView::contextMenuEvent(event);
}
