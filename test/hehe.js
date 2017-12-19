Logline.using(Logline.PROTOCOL.LOCALSTORAGE)
var spaLog=new Logline('spa')
sdkLog=new Logline('sdk')
// spaLog.error('init.failed',{
//     retcode:'EINIT',
//     retmsg:'invalid signature'
// })
Logline.all(function(logs) {
    // process logs here
    console.log('抓取到的日志    '+logs)
});