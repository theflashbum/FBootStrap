package com.flashartofwar.fbootstrap.managers
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

/**
 * @author jessefreeman
 */
public class ResourceManager extends EventDispatcher
{
    private var preloadList:Array = [];
    private var currentLoader:LoaderWrapper;
    private var resources:Array = [];

    public function ResourceManager()
    {
        //Does nothing
    }

    public function addToQueue(url:String, type:String):void {
        preloadList.push(new QueueRequest(url, type))
    }

    public function loadQueue():void
    {
        preload();
    }

    /**
     * Handles preloading our images. Checks to see how many are left then
     * calls loadNext or compositeImage.
     */
    private function preload():void
    {
        var totalLeft:int = preloadList.length;

        if (preloadList.length == 0)
        {
            onPreloadComplete();
        }
        else
        {
            loadNextFile();
        }
    }

    /**
     * Loads the next item in the preloadList
     */
    private function loadNextFile():void
    {
        var currentRequest:QueueRequest = preloadList.shift();
        currentLoader = new LoaderWrapper(currentRequest.type);
        addEventListeners(currentLoader);
        currentLoader.load(new URLRequest(currentRequest.url));
    }

    protected function addEventListeners(target:LoaderWrapper):void {
        target.addEventListener(Event.COMPLETE, onFileLoaded, false, 0, true);
        target.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
    }

    protected function removeEventListeners(target:LoaderWrapper):void {
        target.addEventListener(Event.COMPLETE, onFileLoaded, false, 0, true);
        target.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
    }

    /**
     * Handles onLoad, saves the BitmapData then calls preload
     */
    private function onFileLoaded(event:Event):void
    {

        resources[currentLoader.id] = currentLoader.data;

        //Cleanup
        removeEventListeners(currentLoader);
        currentLoader = null;

        preload();
    }


    private function onIOError(event:IOErrorEvent):void {
    }

    private function onSecurityError(event:SecurityErrorEvent):void {

    }

    private function onPreloadComplete():void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function getResource(id:String):*
    {
        return resources[id];
    }

}
}

import flash.display.Loader;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.LoaderContext;

internal class LoaderWrapper extends EventDispatcher
{
    private var _type:String;
    private var _instance:*;
    private var _id:String;

    public function LoaderWrapper(type:String):void
    {
        _type = type.toLowerCase();

        if (_type == "urlloader")
        {
            _instance = new URLLoader();
        }
        else
        {
            _instance = new Loader();
        }
    }

    protected function get dispatcher():IEventDispatcher
    {
        if (_type == "urlloader")
        {
            return URLLoader(_instance);
        }
        else
        {
            return Loader(_instance).contentLoaderInfo;
        }
    }

    public function load(request:URLRequest, context:LoaderContext = null):void
    {
        _id = request.url;
        if (_type == "urlloader")
        {
            URLLoader(_instance).load(request);
        }
        else
        {
            Loader(_instance).load(request, context);
        }
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        dispatcher.removeEventListener(type, listener, useCapture);
    }


    public function get id():String {
        return _id;
    }

    public function get data():*
    {
        if (_type == "urlloader")
        {
            return URLLoader(_instance).data; 
        }
        else
        {
            return Loader(_instance).content;
        }
    }
}

internal class QueueRequest
{
    public var url:String;
    public var type:String;

    public function QueueRequest(url:String, type:String):void
    {
        this.url = url;
        this.type = type;
    }
}
