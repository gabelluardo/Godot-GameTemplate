class_name ThreadUtility
extends Node

## Load a resource from path using a thread
static func load_resource(path:String, receive_callback:Callable)->void:
	# create thread function to load resource and shut down the tread
	var _thread_load:Callable = func (path:String, callback:Callable, thread:Thread)->PackedScene:
		var _resource:Resource = load(path)
		callback.call_deferred(_resource)
		
		# Thread will finnish itself on main thread using call_deffered.
		thread.wait_to_finish.call_deferred()
		return
	
	# Temporary thread that will shut down itself in the thread function
	var _thread:Thread = Thread.new()
	_thread.start(_thread_load.bind(path, receive_callback, _thread))

## Load a resource from data list {path:String, callback:Callable(resource)}
static func load_resource_list(data_list:Array[Dictionary], finish_callback:Callable = Callable())->void:
	# create thread function to load resources and shut down the tread
	var _thread_load:Callable = func (data_list:Array[Dictionary], finish_callback:Callable, thread:Thread)->PackedScene:
		for _data:Dictionary in data_list:
			var _resource:Resource = load(_data.path)
			_data.callback.call_deferred(_resource)
		
		if !finish_callback.is_null() && finish_callback.is_valid():
			finish_callback.call_deferred()
		# Thread will finnish itself on main thread using call_deffered.
		thread.wait_to_finish.call_deferred()
		return
	
	# Temporary thread that will shut down itself in the thread function
	var _thread:Thread = Thread.new()
	_thread.start(_thread_load.bind(data_list, finish_callback, _thread))


static func callback_list(callback_list:Array[Callable], finish_callback:Callable)->void:
	var _thread_func:Callable = func (callback_list:Array[Callable], finish_callback:Callable, thread:Thread)->void:
		for _callback:Callable in callback_list:
			assert(_callback.is_null() && _callback.is_valid())
			_callback.call()
		
		if !finish_callback.is_null() && finish_callback.is_valid():
			finish_callback.call_deferred()
		# Thread will finnish itself on main thread using call_deffered.
		thread.wait_to_finish.call_deferred()
		return
	
	# Temporary thread that will shut down itself in the thread function
	var _thread:Thread = Thread.new()
	_thread.start(_thread_func.bind(callback_list, finish_callback, _thread))
