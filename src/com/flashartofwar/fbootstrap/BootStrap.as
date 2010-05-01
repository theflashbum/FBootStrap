package com.flashartofwar.fbootstrap {

import com.flashartofwar.fbootstrap.events.BootstrapEvent;
import com.flashartofwar.fbootstrap.managers.ResourceManager;
import com.flashartofwar.fbootstrap.managers.SettingsManager;
import com.flashartofwar.fbootstrap.managers.SingletonManager;
import com.flashartofwar.fbootstrap.managers.URIManager;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class BootStrap extends EventDispatcher {

    protected var location:String;
    protected var containerParams:Array;
    protected var defaultLocation:String;
    protected var uriManager:URIManager = URIManager.instance;
    protected var settings:SettingsManager;
    protected var totalActiveHandlers:int = 0;
    protected var resourceManager:ResourceManager = SingletonManager.getClassReference(ResourceManager);

    public function BootStrap() {

    }

    public function loadConfig(url:String):void
    {
        if (url)
        {
            var configLoader:URLLoader = new URLLoader();
            configLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
            configLoader.load(new URLRequest(url));
        }
        else
        {
            allActiveHandlersCompleted();
        }
    }

    protected function onConfigLoaded(event:Event):void
    {
        event.stopImmediatePropagation();
        var loader:URLLoader = URLLoader(event.target);
        var xml:XML = XML(loader.data);
        activateBootstrap(xml);
    }

    protected function activateBootstrap(configXML:XML):void
    {
        var nodes:XMLList = configXML.*;
        var node:XML;
        var handler:String;

        totalActiveHandlers = nodes.length();

        for each(node in nodes)
        {
            try
            {
                handler = node.@handler;
                this[handler](node);

            } catch(error:Error)
            {
                //Something failed.
                throw new Error("FBootStrap Error: There was no handler for " + node.@handler);
            }
        }

        if (totalActiveHandlers == 0)
        {
            allActiveHandlersCompleted();
        }
    }

    public function parseSettings(data:XML):void
    {
        settings = SettingsManager.instance;
        settings.data = XML(data);

        closeHandler("parseSettings");
    }

    public function parseURIs(data:XML):void
    {
        var uris:XMLList = data.*;
        var uri:XML;
        for each(uri in uris)
        {
            uriManager.addURI(uri.@name, uri.toString());
        }

        closeHandler("parseURIs");
    }

    private function closeHandler(id:String):void {

        totalActiveHandlers --;
        dispatchEvent(new BootstrapEvent(BootstrapEvent.HANDLER_COMPLETE, {id: id}));

        if (totalActiveHandlers <= 0)
        {
            allActiveHandlersCompleted();
        }
    }

    protected function updatePreloader(percent:Number, animated:Boolean = true):void
    {

        //TODO Fire event
    }

    protected function loadResources(data:XML):void
    {
        var resources:XMLList = data.*;
        var resource:XML;

        resourceManager.addEventListener(Event.COMPLETE, onResourcesLoaded);

        for each (resource in resources)
        {
            var url:String = uriManager.getURI(resource.@uri, {filename:resource.@name});
            resourceManager.addToQueue(url, resource.@type);
        }

        resourceManager.loadQueue();
    }

    protected function onResourcesLoaded(event:Event):void
    {
        closeHandler("loadResrouces");
    }

    protected function onLoaderProgress(event:ProgressEvent):void
    {
        event.stopImmediatePropagation();
        updatePreloader(event.bytesLoaded / event.bytesTotal);
    }

    protected function allActiveHandlersCompleted():void
    {
        dispatchEvent(new Event(BootstrapEvent.COMPLETE));
    }

    public function registerFileType(type:String, classPath:String):void
    {

    }

}
}