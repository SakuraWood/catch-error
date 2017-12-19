/**
 * @author {{Lee Sure}} {{smartadelesure@gmail.com}}{{}}
 * @description {{this is a proxy console for the native's}}{{}}
 */
//hook console
let _console = window.console
window.console = {
  log: function () {
    if (store.state.isDebug) {
      _console.log.call(_console, [].slice.call(arguments))
      _console.trace()
    }
  },
  assert: function () {
    _console.assert.call(_console, [].slice.call(arguments))
  },
  context: function () {
    _console.context.call(_console, [].slice.call(arguments))
  },
  error: function () {
    _console.error.call(_console, [].slice.call(arguments))
    _console.trace()
  },
  warn: function () {
    _console.warn.call(_console, [].slice.call(arguments))
    _console.trace()
  },
  time: function () {
    _console.time.call(_console, [].slice.call(arguments))
  },
  timeEnd: function () {
    _console.timeEnd.call(_console, [].slice.call(arguments))
  },
  trace: function () {
    _console.trace.call(_console, [].slice.call(arguments))
  }
}
