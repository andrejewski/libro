// Generated by CoffeeScript 1.6.3
/*
	CASocketRouter
	Signature: IO[instanceof Socket.IO]
	Description: An upgrade for Socket.IO that mimics the
	`app.router` middleware of Express/Connect to allow more
	modularity of Socket.IO.
	Dependencies: Socket.IO [Node.js]
	Exports: CASocketRouter[Function]
*/


/*
CASocketRouter = (io) ->
	io.routes = []
	io.mount = (event, callback = ->) ->
		io.routes[event] = callback
	io.router = (debug = false) ->
		io.sockets.on 'connection', (socket) ->
			for event, callback in io.routes
				name = 'io/'+event
				socket.on event, (data, done) ->
					(console.time name) if debug
					next = (error, data) ->
						(console.timeEnd name) if debug
						done {error, data}
					callback.call socket, data, next, io.sockets
*/


(function() {
  var CASocketRouter;

  CASocketRouter = function(io) {
    if (!io) {
      return CASocketRouter;
    }
    io.routes = [];
    io.mount = function(head) {
      var callback, event, route;
      if (typeof head === 'object') {
        for (event in head) {
          callback = head[event];
          io.mount(event, callback);
        }
        return;
      }
      route = Array.prototype.slice.call(arguments, 0);
      if (route.length === 2) {
        route.unshift('*');
      }
      return io.routes.push(route);
    };
    io.space = function(namespace) {
      return function(eventOrHead, callback) {
        var event;
        if (typeof eventOrHead === 'object') {
          for (event in eventOrHead) {
            callback = eventOrHead[event];
            io.mount(namespace, event, callback);
          }
          return;
        }
        return io.mount(namespace, eventOrHead, callback);
      };
    };
    io.build = function() {
      var On, callback, event, namespace, res, route, _i, _len, _ref, _results;
      io.spaces = [];
      _ref = io.routes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        route = _ref[_i];
        namespace = route[0], event = route[1], callback = route[2];
        res = function(socket, callback) {
          return function(req, done) {
            var next;
            next = function(error, data) {
              return done({
                error: error,
                data: data
              });
            };
            return callback.call(socket, req, next, io.sockets);
          };
        };
        if (namespace !== '*') {
          On = (io.of(namespace)).on;
        } else {
          On = io.sockets.on;
        }
        _results.push(io.spaces.push(function(io) {
          return On('connection', function(socket) {
            return socket.on(event, res(socket, callback));
          });
        }));
      }
      return _results;
    };
    return io.router = function() {
      var func, _i, _len, _ref;
      if (!io._routerStarted) {
        io.build();
        _ref = io.spaces;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          func = _ref[_i];
          func(io);
        }
        return io._routerStarted = true;
      }
    };
  };

  module.exports = CASocketRouter;

}).call(this);
