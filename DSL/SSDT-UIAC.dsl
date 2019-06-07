
// USBInjectAll configuration/override

DefinitionBlock ("", "SSDT", 2, "15isk-14isk", "UIAC-ALL", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_A12F", Package()
            {
                //"port-count", Buffer() { 21, 0, 0, 0 },
                "ports", Package()
                {
                    "HS02", Package()    // HS component of USB 3.0 right rear 
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x02, 0, 0, 0 },
                    },
                    "HS03", Package()    // HS component of USB 3.0 right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x03, 0, 0, 0 },
                    },
                    "HS04", Package()    // Bluetooth 
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },
                    
                    "HS05", Package()    // Camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 0x01, 0, 0, 0 },
                    },

                    "HS06", Package()    // USB 2.0 left
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x06, 0, 0, 0 },
                    },
                    
                    "HS07", Package()    // USB 2.0-CRW card reader
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 0x07, 0, 0, 0 },
                    },

                    "SS02", Package()    // USB 3.0 right front
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x12, 0, 0, 0 },
                    },
                    "SS03", Package()    // USB 3.0 right reart
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 0x13, 0, 0, 0 }
                    }
                }
            }
        })
    }
 }

// EOF