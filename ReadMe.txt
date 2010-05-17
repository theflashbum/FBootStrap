Hello,

Welcome to FBootStrap, this is a simple library to help load in core
assets to your Flash Application such as a config files, external
resources, and other useful utilities.

**Right now FBootStrap is dependant on F*CSS's (http://github.com/theflashbum/fcss)
Type utility. This will be fixed in a later version so the SWC is included
in the build/libs directory.**

Understanding the config file

This is a basic config file:

<?xml version="1.0" encoding="UTF-8"?>
<config>
    <uris handler="parseURIs">
        <uri name="fcss"><![CDATA[css/${filename}.fcss]]></uri>
        <uri name="xml"><![CDATA[xml/${filename}.xml]]></uri>
    </uris>
    <settings handler="parseSettings">
        <property id="version" type="string"><![CDATA[1.0.0]]></property>
        <property id="debug" type="boolean">true</property>
    </settings>
    <resources handler="loadResources">
        <file name="main.styles" uri="fcss" type="urlloader"/>
        <file name="decalsheet" uri="xml" type="urlloader"/>
    </resources>
</config>

As you can see in this example the config is broken down into 3 parts: uris,
settings, and resources. You can add any "data block" you would like. Each
block is mapped to a method (in the handler node attribute) which handles
automatically passing the xml block to that method in the FBootStrap class.

These 3 handles are built into the library. Lets talk about each one.

URIs
 Coming Soon!

Settings
 Coming Soon!

Resources
 Coming Soon!


Instantiating the FBootStrap

FBootStrap is designed to be simple to use. Currently there is only one event
which signals when the boot process is complete. Lets take a look at an example:

------------------------------------------------------------------------------------

// Use the SingletonManager to make sure there is only one instance of the BootStrap
var bootstrap:BootStrap = SingletonManager.getClassReference(BootStrap);

// Add an event listener for complete
bootstrap.addEventListener(BootstrapEvent.COMPLETE, onBootStrapComplete);

// Load in a config xml
bootstrap.loadConfig(_configURL);

------------------------------------------------------------------------------------

That is it. In future versions of the code there will be more events to cover
load details better.