//
// Created by Kaze Fx on 2023/12/28.
//

#ifndef QT_TEST_KATEXTAREA_H
#define QT_TEST_KATEXTAREA_H

#include <QDebug>
#include <QtQuick/private/qquicktextedit_p.h>
#include <QtQuick/qquicktextdocument.h>
#include <QTextBlock>
#include <vector>
#include <QCursor>

// class KaTextAreaPrivate;

class KaTextArea : public QQuickTextEdit {
Q_OBJECT

    Q_PROPERTY(std::vector<int> tline2lline READ getLines)
    Q_PROPERTY(std::vector<int> lineHeights READ getLineH)
    Q_PROPERTY(int cursorLineNum READ getCursorLineNum)
    Q_PROPERTY(std::vector<int> cursorYH READ getCursorYH)
    Q_PROPERTY(std::vector<int> refreshList READ getRefreshList)
public:

    KaTextArea(QQuickItem *parent = nullptr) : QQuickTextEdit(parent) {
        tabDist(font());
        connect(this, &KaTextArea::fontChanged, this, &KaTextArea::tabDist);
        connect(this, &KaTextArea::lineCountChanged, this, &KaTextArea::lineCh);
        connect(this, &QQuickItem::widthChanged, this, &KaTextArea::lineRefresh);
        lineHeights.clear();
    }

    virtual ~KaTextArea() {}

    void tabDist(const QFont &font) { setTabStopDistance(font.pixelSize() * 2); }

    std::vector<int> getLines() {
        auto doc = this->textDocument();
        auto tdoc = doc->textDocument();
        std::vector<int> ret;
        for (auto i = tdoc->begin(); i != tdoc->end(); i = i.next()) {
            ret.push_back(i.layout()->lineCount());
            // auto h = (int) i.layout()->boundingRect().height();
        }
        return ret;
    }

    std::vector<int> getLineH() {
        auto doc = this->textDocument();
        auto tdoc = doc->textDocument();
        int length = lineHeights.size();
        if (length == tdoc->blockCount())
            return lineHeights;
        for (auto i = tdoc->findBlockByNumber(length); i != tdoc->end(); i = i.next()) {
            lineHeights.push_back(i.layout()->boundingRect().height());
        }
        return lineHeights;
    }

    void refreshLineH(int lineNum) {
        auto doc = this->textDocument();
        auto tdoc = doc->textDocument();
        auto blk = tdoc->findBlockByNumber(lineNum - 1);
        lineHeights[lineNum - 1] = blk.layout()->boundingRect().height();
    }

    int getCursorLineNum() {
        auto blk = getCursorBlock();
        return blk.blockNumber() + 1;
    }

    QTextBlock getCursorBlock() {
        auto rect = cursorRectangle();
        int y = 0;
        int height = 0;
        for (auto i = textDocument()->textDocument()->begin();
             i != textDocument()->textDocument()->end(); i = i.next()) {
            height = i.layout()->boundingRect().height();
            if (y <= rect.y() && rect.y() + rect.height() <= y + height) {
                return i;
            }
            y += i.layout()->boundingRect().height();
        }
        return textDocument()->textDocument()->end();
    }

    std::vector<int> getCursorYH() {
        std::vector<int> ret;
        auto blk = getCursorBlock();
        int y = 0;
        if (blk != textDocument()->textDocument()->begin()) {
            for (auto i = blk.previous();; i = i.previous()) {
                y += i.layout()->boundingRect().height();
                if (i == textDocument()->textDocument()->begin())
                    break;
            }
        }
        auto height = blk.layout()->boundingRect().height();
        ret.push_back(y);
        ret.push_back(height);
        return ret;
    }

    void lineRefresh() {
        _lineRefresh();
        emit widthFreshed();
    }

    void lineCh() {
        auto doc = this->textDocument();
        auto tdoc = doc->textDocument();
        int lineN = getCursorLineNum();
        if (tdoc->blockCount() > lineHeights.size()) {
            getLineH();
        } else if (tdoc->blockCount() == lineHeights.size()) {
            refreshLineH(lineN);
        } else {
            while (tdoc->blockCount() < lineHeights.size())
                lineHeights.pop_back();
            _lineRefresh();
        }
        emit lineFreshed();
    }

    void _lineRefresh() {
        auto doc = this->textDocument();
        auto tdoc = doc->textDocument();
        refresh.clear();
        if (lineHeights.size() < tdoc->blockCount())
            getLineH();
        for (auto i = tdoc->begin(); i != tdoc->end(); i = i.next()) {
            if (lineHeights[i.blockNumber()] != i.layout()->boundingRect().height()) {
                lineHeights[i.blockNumber()] = i.layout()->boundingRect().height();
                refresh.push_back(i.blockNumber());
            }
        }
    }

    std::vector<int> getRefreshList() {
        _lineRefresh();
        return refresh;
    }

private:
    std::vector<int> lineHeights;
    std::vector<int> refresh;
signals:

    void lineFreshed();

    void widthFreshed();
};

// void text(KaTextArea *var) {
// }

#endif //QT_TEST_KATEXTAREA_H
