###
# Created by superfeng on 2017/8/17.
###
_ = fridge

class Notification
    ###
    # 构造函数
    ###
    constructor: ->
        @errorCodeArr = []
        @errorData = []
        @daoManager = {}
        @overDateFoods = []
        @DataObject =
            "mac":"",
            "mid":"",
            "data":"",
            "t":"",
            "itemId":[],
            "code":[],
            "evt":0

    ###
    # 初始化函数
    ###
    init: =>
        ###
        # 解析故障代码
        # @param data {array}
        ###
        parseData = (data)=>
            @errorData = []
            if data.length > 0
                data.forEach (item)=>
                    switch item
                        when 1
                            errorCode = 'E0'
                            errorType = '冷藏室传感器故障'
                        when 2
                            errorCode = 'E8'
                            errorType = '冷藏室感温包2故障冷藏室顶'
                        when 3
                            errorCode = 'E2'
                            errorType = '冷冻室传感器故障'
                        when 4
                            errorCode = 'E1'
                            errorType = '变温室传感器故障'
                        when 5
                            errorCode = 'E5'
                            errorType = '除霜传感器故障'
                        when 6
                            errorCode = 'E4'
                            errorType = '制冰室传感器故障'
                        when 7
                            errorCode = 'E7'
                            errorType = '瞬冷冻室红外传感器故障'
                        when 8
                            errorCode = 'E9'
                            errorType = '制冰机红外传感器故障'
                        when 9
                            errorCode = 'E3'
                            errorType = '瞬冷冻室传感器故障'
                        when 10
                            errorCode = 'H6'
                            errorType = '冷冻风扇电机故障'
                        when 11
                            errorCode = 'H3'
                            errorType = '冷凝风扇故障'
                        when 12
                            errorCode = 'C1'
                            errorType = '变频器通讯故障'
                        when 13
                            errorCode = 'C7'
                            errorType = '变频驱动模块异常'
                        when 14
                            errorCode = 'PL'
                            errorType = '母线电压故障（不足）'
                        when 15
                            errorCode = 'PH'
                            errorType = '母线电压故障（过剩）'
                        when 16
                            errorCode = 'C5'
                            errorType = '启动、同步或过流检测故障'
                        when 17
                            errorCode = 'C9'
                            errorType = '型号判定故障'
                        when 18
                            errorCode = 'E6'
                            errorType = '环温传感器故障'
                        when 19
                            errorCode = 'HU'
                            errorType = '湿度传感器故障'
                        when 20
                            errorCode = 'C2'
                            errorType = '主板EPROM读写错误故障'
                        when 21
                            errorCode = 'JF'
                            errorType = '显示板检测板通讯故障'
                        when 22
                            errorCode = 'H4'
                            errorType = '除霜加热器故障'
                        when 23
                            errorCode = 'H2'
                            errorType = '制冰齿轮箱故障'
                        when 24
                            errorCode = 'H1'
                            errorType = '制冰剂管堵或压缩机相关故障'
                        when 25
                            errorCode = 'H5'
                            errorType = '电动阀故障'
                        when 26
                            errorCode = 'C3'
                            errorType = '变频器电路故障'
                        when 27
                            errorCode = 'C4'
                            errorType = '变频器软件重置功能故障'
                        when 28
                            errorCode = 'C6'
                            errorType = '接线错误、控制板故障'
                        when 29
                            errorCode = 'EC'
                            errorType = '通讯故障'
                    @errorData.push({"errorCode":errorCode,"errorType":errorType})

        ###
        # 动态添加故障内容
        # @param parentId {string} 父节点的ID
        # @param dataObject {object} 提供需要显示的数据信息
        # @param attributeArray {array} 提供用于需要显示的属性
        ###
        addTableContent = (parentId, dataObject, attributeArray)=>
            parent = document.getElementById parentId
            dataObject.forEach (item)->
                tRow = document.createElement('tr')
                attributeArray.forEach (attribute)->
                    tData = document.createElement('td')
                    text = document.createTextNode(attribute)
                    tData.appendChild(text)
                    tRow.appendChild(tData)
                parent.appendChild(tRow)

        ###
        # 绑定事件
        ###
        bindEvent = =>
            document.addEventListener('touchstart', (event)=>
                target = event.target || event.srcElement
                (
                    find = no
                    switch target.id
                        when 'btn-back'
                            _.closePage()
                            find = yes
                    if find
                        break
                    else
                        target = target.parentNode
                ) while target.nodeName isnt 'BODY'
                ''
            , true)

        ###
        # 本地化
        ###
        localize = ->
            $('#txtEdit').text(lang.push_page_title)
            $('#err-code').text(lang.err_code)
            $('#err-type').text(lang.err_type)
            $('#name').text(lang.food_name)
            $('#position').text(lang.position)
            $('#storageDate').text(lang.storage_date)

        whichRoom = (pos)->
            switch pos
                when '0'
                    room = '冷藏室'
                when '1'
                    room = '超冰点室'
                when '2'
                    room = '瞬冷冻室'
                when '3'
                    room = '冷冻室'
                when '4'
                    room = '变温室'
            return room

        dateFormat = (dateInit)->
            year = dateInit.match(/\d+/g)[0]
            month = dateInit.match(/\d+/g)[1]
            date = dateInit.match(/\d+/g)[2]

        ###
        # 初始化界面
        ###
        initUI = =>
            if (@DataObject.t == "error")
                $("#refFoodError").hide()
                $("#error").show()
                #显示故障
                parseData(@DataObject.code)
                addTableContent('malfunction', @errorData, ['errorCode', 'errorType'])
            else if (@DataObject.t == "foodExpire" || @DataObject.t == "foodExpireSoon")
                #显示食材过期
                $("#error").hide()
                $("#refFoodError").show()
                @daoManager.getAllItem @DataObject.mac, (foodArray)=>
                    foodArray.forEach (item)=>
                        @DataObject.itemId.forEach (itemId)=>
                            if itemId == item.Value.id
                                @overDateFoods.push item
                    if @overDateFoods.length > 0
                        addTableContent('expiration', @overDateFoods, ['name', 'pos', ])
                    else
                        @daoManager.queryItemsPush (foodArray)=>
                            foodArray.forEach (item)=>
                                @DataObject.itemId.forEach (itemId)=>
                                    if itemId == item.Value.id
                                        @overDateFoods.push item


        ###
        # 解析statue data数据
        ###
        parseStates = (pushData)=>
            if (pushData != "")
                try
                    jsonData = JSON.parse(pushData)

                    @DataObject.mac = jsonData.mac
                    @DataObject.mid = jsonData.mid
                    @DataObject.data = jsonData.data
                    @DataObject.t = @DataObject.data.t

                    if (@DataObject.t == "error")
                        @DataObject.evt = @DataObject.data.evt
                        #@DataObject.code = @DataObject.data.code
                        #现在收到的仅仅是一个数据而不是一个数组，先处理一下
                        (@DataObject.code).push(@DataObject.data.code)
                    else if(@DataObject.t == "foodExpire"||@DataObject.t == "foodExpireSoon")
                        @DataObject.itemId = @DataObject.data.itemId
                catch err
                    console.log "parse states error: #{err}"
            else
                navigator.PluginInterface.closePage()
        ###
        # 解析url初始值
        ###
        parseUrlData = =>
            _.mac = _.getQueryStringByName('mac')
            ext = _.getQueryStringByName("ext")

        ###
        # 初始化开始
        ###
        FastClick.attach(document.body)
        parseUrlData()
        @daoManager = new _.remoteStorage
        parseStates()
        initUI()
        if _.isDebug
            $('#loading').hide()
        else
            _.loadPageInfo( =>
                localize()
                _.getStates =>
                    @errorCodeArr = _.dataObject.Er
                    parseData()
                    addTableContent()
            )
        bindEvent()

_.notification = new Notification()

window.addEventListener('DOMContentLoaded', _.notification.init.bind(_.notification), false)

console.log _.aaa
