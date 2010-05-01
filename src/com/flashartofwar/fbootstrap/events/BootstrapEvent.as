package com.flashartofwar.fbootstrap.events {

public class BootstrapEvent extends AbstractDataEvent {

    public static const HANDLER_COMPLETE:String = "handlerComplete";
    public static const COMPLETE:String = "com.flashartofwar.fbootstrap.events.BootstrapEvent.COMPLETE"

    public function BootstrapEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(this, type, data, bubbles, cancelable);
    }
}
}