import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property int tabWidthBehavior : FluTabViewType.Equal
    property int closeButtonVisibility : FluTabViewType.Always
    property bool colorful: false
    property int inner_w: 35
    property int itemWidth: 146
    property bool addButtonVisibility: true
    property bool moveItem: true
    signal newPressed
    signal itemMoved(var from, var to)
    signal itemRemove(var idx)
    id:control
    implicitHeight: height
    implicitWidth: width
    // anchors.fill: {
    //     if(parent)
    //         return parent
    //     return undefined
    // }
    width: parent.width
    height: tab_nav.height
    QtObject {
        id: d
        property int dragIndex: -1
        property bool dragBehavior: false
        property bool itemPress: false
        property int maxEqualWidth: 100
    }
    MouseArea{
        anchors.fill: parent
        preventStealing: true
    }
    ListModel{
        id:tab_model
    }
    FluIconButton{
        id:btn_new
        visible: addButtonVisibility
        width: addButtonVisibility ? 34 : 0
        height: 34
        x: Math.min(tab_nav.contentWidth,tab_nav.width)
        anchors.verticalCenter: parent.verticalCenter
        iconSource: FluentIcons.Add
        onClicked: {
            newPressed()
        }
    }
    ListView{
        id:tab_nav
        height: Math.max(contentItem.childrenRect.height, 40)
        orientation: ListView.Horizontal
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            rightMargin: btn_new.width
        }
        interactive: false
        model: tab_model
        move: Transition {
            NumberAnimation { properties: "x"; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { properties: "y"; duration: 100; easing.type: Easing.OutCubic }
        }
        moveDisplaced: Transition {
            NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.OutCubic}
            NumberAnimation { properties: "y"; duration: 100;  easing.type: Easing.OutCubic }
        }
        clip: true
        ScrollBar.horizontal: ScrollBar{
            id: scroll_nav
            policy: ScrollBar.AlwaysOff
        }
        delegate:  Item{
            width: item_layout.width
            height: item_layout.height
            z: item_mouse_drag.pressed ? 1000 : 1
            Item{
                id:item_layout
                width: item_container.width
                height: item_container.height
                Item{
                    id:item_container
                    property real timestamp: new Date().getTime()
                    height: item_text.height
                    width: {
                        if(tabWidthBehavior === FluTabViewType.Equal){
                            return Math.max(Math.min(d.maxEqualWidth,tab_nav.width/tab_nav.count), inner_w + item_btn_close.width)
                        }
                        if(tabWidthBehavior === FluTabViewType.SizeToContent){
                            return itemWidth
                        }
                        if(tabWidthBehavior === FluTabViewType.Compact){
                            return item_mouse_hove.containsMouse || item_btn_close.hovered || tab_nav.currentIndex === index  ? itemWidth : inner_w + item_btn_close.width
                        }
                        return Math.max(Math.min(d.maxEqualWidth,tab_nav.width/tab_nav.count), inner_w + item_btn_close.width)
                    }
                    Behavior on x { enabled: d.dragBehavior; NumberAnimation { duration: 200 } }
                    Behavior on y { enabled: d.dragBehavior; NumberAnimation { duration: 200 } }
                    MouseArea{
                        id:item_mouse_hove
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                    FluTooltip{
                        visible: item_mouse_hove.containsMouse
                        text:item_text.text
                        delay: 1000
                    }
                    MouseArea{
                        id:item_mouse_drag
                        property int _from
                        property int _to
                        anchors.fill: parent
                        drag.target: moveItem ? item_container : drag.target
                        drag.axis: moveItem ? Drag.XAxis : drag.axis
                        onWheel: (wheel)=>{
                                     if (wheel.angleDelta.y > 0) scroll_nav.decrease()
                                     else scroll_nav.increase()
                                 }
                        onPressed: {
                            if (!moveItem)
                                return
                            _from = -1
                            _to = -1
                            d.itemPress = true
                            item_container.timestamp = new Date().getTime();
                            d.dragBehavior = false;
                            var pos = tab_nav.mapFromItem(item_container, 0, 0)
                            d.dragIndex = model.index
                            item_container.parent = tab_nav
                            item_container.x = pos.x
                            item_container.y = pos.y
                        }
                        onReleased: {
                            if (!moveItem)
                                return
                            if (_from !== -1 && _to !== -1)
                                itemMoved(_from, _to)
                            d.itemPress = false
                            timer.stop()
                            var timeDiff = new Date().getTime() - item_container.timestamp
                            if (timeDiff < 300) {
                                tab_nav.currentIndex = index
                            }
                            d.dragIndex = -1;
                            var pos = tab_nav.mapToItem(item_layout, item_container.x, item_container.y)
                            item_container.parent = item_layout;
                            item_container.x = pos.x;
                            item_container.y = pos.y;
                            d.dragBehavior = true;
                            item_container.x = 0;
                            item_container.y = 0;
                        }
                        onPositionChanged: {
                            if (!moveItem)
                                return
                            var pos = tab_nav.mapFromItem(item_container, 0, 0)
                            updatePosition(pos)
                            if(pos.x<0){
                                timer.isIncrease = false
                                timer.restart()
                            }else if(pos.x>tab_nav.width-itemWidth){
                                timer.isIncrease = true
                                timer.restart()
                            }else{
                                timer.stop()
                            }
                        }
                        Timer{
                            id:timer
                            property bool isIncrease: true
                            interval: 10
                            repeat: true
                            onTriggered: {
                                if(isIncrease){
                                    if(tab_nav.contentX>=tab_nav.contentWidth-tab_nav.width){
                                        return
                                    }
                                    tab_nav.contentX = tab_nav.contentX+2
                                }else{
                                    if(tab_nav.contentX<=0){
                                        return
                                    }
                                    tab_nav.contentX = tab_nav.contentX-2
                                }
                                item_mouse_drag.updatePosition(tab_nav.mapFromItem(item_container, 0, 0))
                            }
                        }
                        function updatePosition(pos){
                            var idx = tab_nav.indexAt(pos.x+tab_nav.contentX+1, pos.y)
                            var firstIdx = tab_nav.indexAt(tab_nav.contentX+1, pos.y)
                            var lastIdx = tab_nav.indexAt(tab_nav.width+tab_nav.contentX-1, pos.y)
                            if(lastIdx === -1){
                                lastIdx = tab_nav.count-1
                            }
                            if (idx!==-1 && idx >= firstIdx && idx <= lastIdx && d.dragIndex !== idx) {
                                tab_model.move(d.dragIndex, idx, 1)
                                if (_from === -1 || _to === -1) {
                                    _from = d.dragIndex
                                    _to = idx
                                } else {
                                    _to = idx
                                }
                                d.dragIndex = idx;
                            }
                        }
                    }
                    FluRectangle{
                        anchors.fill: parent
                        radius: [6,6,6,6]
                        color: {
                            if(item_mouse_hove.containsMouse || item_btn_close.hovered){
                                return FluTheme.itemHoverColor
                            }
                            if(tab_nav.currentIndex === index){
                                return colorful ? (_text.slice(0, 1) === "V" ? FluColors.Green.light : FluColors.Red.light) : FluTheme.itemCheckColor
                            }
                            return colorful ? (_text.slice(0, 1) === "V" ? FluColors.Green.light : FluColors.Red.light) : FluTheme.itemCheckColor
                        }
                    }
                    RowLayout{
                        spacing: 0
                        height: item_text.height
                        FluText{
                            id:item_text
                            text: _text
                            Layout.leftMargin: 10
                            visible: {
                                if(tabWidthBehavior === FluTabViewType.Equal){
                                    return true
                                }
                                if(tabWidthBehavior === FluTabViewType.SizeToContent){
                                    return true
                                }
                                if(tabWidthBehavior === FluTabViewType.Compact){
                                    return item_mouse_hove.containsMouse || item_btn_close.hovered || tab_nav.currentIndex === index
                                }
                                return false
                            }
                            Layout.preferredWidth: visible ? item_container.width - item_btn_close.width : 0
                            topPadding: 10
                            bottomPadding: topPadding
                            elide: Text.ElideRight
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                    FluIconButton{
                        id:item_btn_close
                        iconSource: FluentIcons.ChromeClose
                        iconSize: 10
                        width: visible ? 24 : 0
                        height: 24
                        visible: {
                            if(closeButtonVisibility === FluTabViewType.Nerver)
                                return false
                            if(closeButtonVisibility === FluTabViewType.OnHover)
                                return item_mouse_hove.containsMouse || item_btn_close.hovered
                            return true
                        }
                        anchors{
                            right: parent.right
                            rightMargin: 5
                            verticalCenter: parent.verticalCenter
                        }
                        onClicked: {
                            itemRemove(index)
                            tab_model.remove(index)
                        }
                    }
                    FluDivider{
                        width: 1
                        height: 16
                        orientation: Qt.Vertical
                        anchors{
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }
                    }
                }
            }
        }
    }
    function createTab(text){
        return {_text:text}
    }
    function appendTab(text){
        tab_model.append(createTab(text))
    }
    function setTabList(list){
        tab_model.clear()
        tab_model.append(list)
    }
    function count(){
        return tab_model.count
    }
}
