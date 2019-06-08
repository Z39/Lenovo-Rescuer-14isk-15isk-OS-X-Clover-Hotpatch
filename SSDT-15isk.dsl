// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// Created by : z39
// Credits : RehabMan

DefinitionBlock("", "SSDT", 2, "15isk", "_HACK", 0)
{
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)

    // All _OSI calls in DSDT are routed to XOSI...
    // XOSI simulates "Windows 2012" (which is Windows 8)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //  Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //  http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx
        Store(Package()
        {
            "Windows",              // generic Windows query
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            "Windows 2013",         // Windows 8.1/Windows Server 2012 R2
            "Windows 2015",         // Windows 10/Windows Server TP
            "Windows 2016",         // Windows 10, version 1607
            "Windows 2017",         // Windows 10, version 1703
            "Windows 2017.2",       // Windows 10, version 1709
            "Windows 2018",         // Windows 10, version 1803
            "Windows 2018.2",       // Windows 10, version 1809
            "Windows 2019",         // Windows 10, version 1903
         }, Local0)
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }

//  USB related
//

    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, Zero, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, Zero, }) }
        External(XPRW, MethodObj)
        Return (XPRW(Arg0, Arg1))
    }

    // Override for USBInjectAll.kext
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

                    },
                },
            },
        })
    }



// Automatic injection of HDAU properties
    
    External(_SB.PCI0.HDAU, DeviceObj)
    
    Method(_SB.PCI0.HDAU._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return (Package ()
        {
            "layout-id", Buffer() { 3, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
        })
    }
    
    // Automatic injection of HDEF properties

    External(_SB.PCI0.HDEF, DeviceObj)
    
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return(Package()
        {
            "layout-id", Buffer() { 3, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        })
    }

//
// For disabling the discrete GPU
//

    External(_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
    External(_SB.PCI0.PEGP.DGFX._OFF, MethodObj)

    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            // disable discrete graphics (Nvidia/Radeon) if it is present
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF)) { \_SB.PCI0.PEG0.PEGP._OFF() }
            If (CondRefOf(\_SB.PCI0.PEGP.DGFX._OFF)) { \_SB.PCI0.PEGP.DGFX._OFF() }
        }
    }

//
// Display backlight implementation
//
// From SSDT-PNLF.dsl
// Adding PNLF device for IntelBacklight.kext or AppleBacklight.kext+AppleBacklightFixup.kext

#define FBTYPE_SANDYIVY 1
#define FBTYPE_HSWPLUS 2
#define FBTYPE_CFL 3

#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9
#define SKYLAKE_PWMMAX 0x56c
#define CUSTOM_PWMMAX_07a1 0x07a1
#define CUSTOM_PWMMAX_1499 0x1499
#define COFFEELAKE_PWMMAX 0xffff

    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(RMCF.LEVW, IntObj)
    External(RMCF.GRAN, IntObj)
    External(RMCF.FBTP, IntObj)
    External(_SB.PCI0.IGPU, DeviceObj)

    Scope(_SB.PCI0.IGPU)
    {
        OperationRegion(RMP3, PCI_Config, 0, 0x14)
    }

    // For backlight control
    Device(_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        // _UID is set depending on PWMMax to match profiles in AppleBacklightFixup.kext Info.plist
        // 14: Sandy/Ivy 0x710
        // 15: Haswell/Broadwell 0xad9
        // 16: Skylake/KabyLake 0x56c (and some Haswell, example 0xa2e0008)
        // 17: custom LMAX=0x7a1
        // 18: custom LMAX=0x1499
        // 19: CoffeeLake 0xffff
        // 99: Other (requires custom AppleBacklightInjector.kext/AppleBackightFixup.kext)
        Name(_UID, 0)
        Name(_STA, 0x0B)

        Field(^RMP3, AnyAcc, NoLock, Preserve)
        {
            Offset(0x02), GDID,16,
            Offset(0x10), BAR1,32,
        }

        // IGPU PWM backlight register descriptions:
        //   LEV2 not currently used
        //   LEVL level of backlight in Sandy/Ivy
        //   P0BL counter, when zero is vertical blank
        //   GRAN see description below in INI1 method
        //   LEVW should be initialized to 0xC0000000
        //   LEVX PWMMax except FBTYPE_HSWPLUS combo of max/level (Sandy/Ivy stored in MSW)
        //   LEVD level of backlight for Coffeelake
        //   PCHL not currently used
        OperationRegion(RMB1, SystemMemory, BAR1 & ~0xF, 0xe1184)
        Field(RMB1, AnyAcc, Lock, Preserve)
        {
            Offset(0x48250),
            LEV2, 32,
            LEVL, 32,
            Offset(0x70040),
            P0BL, 32,
            Offset(0xc2000),
            GRAN, 32,
            Offset(0xc8250),
            LEVW, 32,
            LEVX, 32,
            LEVD, 32,
            Offset(0xe1180),
            PCHL, 32,
        }

        // INI1 is common code used by FBTYPE_HSWPLUS and FBTYPE_CFL
        Method(INI1, 1)
        {
            // INTEL OPEN SOURCE HD GRAPHICS, INTEL IRIS GRAPHICS, AND INTEL IRIS PRO GRAPHICS PROGRAMMER'S REFERENCE MANUAL (PRM)
            // FOR THE 2015-2016 INTEL CORE PROCESSORS, CELERON PROCESSORS AND PENTIUM PROCESSORS BASED ON THE "SKYLAKE" PLATFORM
            // Volume 12: Display (https://01.org/sites/default/files/documentation/intel-gfx-prm-osrc-skl-vol12-display.pdf)
            //   page 189
            //   Backlight Enabling Sequence
            //   Description
            //   1. Set frequency and duty cycle in SBLC_PWM_CTL2 Backlight Modulation Frequency and Backlight Duty Cycle.
            //   2. Set granularity in 0xC2000 bit 0 (0 = 16, 1 = 128).
            //   3. Enable PWM output and set polarity in SBLC_PWM_CTL1 PWM PCH Enable and Backlight Polarity.
            //   4. Change duty cycle as needed in SBLC_PWM_CTL2 Backlight Duty Cycle.
            // This 0xC value comes from looking what OS X initializes this
            // register to after display sleep (using ACPIDebug/ACPIPoller)
            If (0 == (2 & Arg0))
            {
                Local5 = 0xC0000000
                If (CondRefOf(\RMCF.LEVW)) { If (Ones != \RMCF.LEVW) { Local5 = \RMCF.LEVW } }
                ^LEVW = Local5
            }
            // from step 2 above (you may need 1 instead)
            If (4 & Arg0)
            {
                If (CondRefOf(\RMCF.GRAN)) { ^GRAN = \RMCF.GRAN }
                Else { ^GRAN = 0 }
            }
        }

        Method(_INI)
        {
            // IntelBacklight.kext takes care of this at load time...
            // If RMCF.BKLT does not exist, it is assumed you want to use AppleBacklight.kext...
            Local4 = 1
            If (CondRefOf(\RMCF.BKLT)) { Local4 = \RMCF.BKLT }
            If (!(1 & Local4)) { Return }

            // Adjustment required when using AppleBacklight.kext
            Local0 = ^GDID
            Local2 = Ones
            If (CondRefOf(\RMCF.LMAX)) { Local2 = \RMCF.LMAX }
            // Determine framebuffer type (for PWM register layout)
            Local3 = 0
            If (CondRefOf(\RMCF.FBTP)) { Local3 = \RMCF.FBTP }

            // Now fixup the backlight PWM depending on the framebuffer type
            // At this point:
            //   Local4 is RMCF.BLKT value, if specified (default is 1)
            //   Local0 is device-id for IGPU
            //   Local2 is LMAX, if specified (Ones means based on device-id)
            //   Local3 is framebuffer type

            // check Sandy/Ivy
            If (FBTYPE_SANDYIVY == Local3 || Ones != Match(Package()
            {
                // Sandy HD3000
                0x010b, 0x0102,
                0x0106, 0x1106, 0x1601, 0x0116, 0x0126,
                0x0112, 0x0122,
                // Ivy
                0x0152, 0x0156, 0x0162, 0x0166,
                0x016a,
                // Arrandale
                0x0046, 0x0042,
            }, MEQ, Local0, MTR, 0, 0))
            {
                if (Ones == Local2) { Local2 = SANDYIVY_PWMMAX }
                // change/scale only if different than current...
                Local1 = ^LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMMax but retain current backlight level by scaling
                    Local0 = (^LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = ^P0BL, ^P0BL == Local7, ) { }
                    Local3 = Local2 << 16
                    If (Local2 > Local1)
                    {
                        // PWMMax is getting larger... store new PWMMax first
                        ^LEVX = Local3
                        ^LEVL = Local0
                    }
                    Else
                    {
                        // otherwise, store new brightness level, followed by new PWMMax
                        ^LEVL = Local0
                        ^LEVX = Local3
                    }
                }
            }
            // check CoffeeLake
            ElseIf (FBTYPE_CFL == Local3 || Ones != Match(Package()
            {
                // CoffeeLake identifiers from AppleIntelCFLGraphicsFramebuffer.kext
                0x3e9b, 0x3ea5, 0x3e92, 0x3e91,
            }, MEQ, Local0, MTR, 0, 0))
            {
                if (Ones == Local2) { Local2 = COFFEELAKE_PWMMAX }
                INI1(Local4)
                // change/scale only if different than current...
                Local1 = ^LEVX
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMMax but retain current backlight level by scaling
                    Local0 = (^LEVD * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = ^P0BL, ^P0BL == Local7, ) { }
                    If (Local2 > Local1)
                    {
                        // PWMMax is getting larger... store new PWMMax first
                        ^LEVX = Local2
                        ^LEVD = Local0
                    }
                    Else
                    {
                        // otherwise, store new brightness level, followed by new PWMMax
                        ^LEVD = Local0
                        ^LEVX = Local2
                    }
                }
            }
            // otherwise must be Haswell/Broadwell/Skylake/KabyLake/KabyLake-R (FBTYPE_HSWPLUS)
            Else
            {
                if (Ones == Local2)
                {
                    // check Haswell and Broadwell, as they are both 0xad9 (for most common ig-platform-id values)
                    If (Ones != Match(Package()
                    {
                        // Haswell
                        0x0d26, 0x0a26, 0x0d22, 0x0412, 0x0416, 0x0a16, 0x0a1e, 0x0a1e, 0x0a2e, 0x041e, 0x041a,
                        // Broadwell
                        0x0bd1, 0x0bd2, 0x0BD3, 0x1606, 0x160e, 0x1616, 0x161e, 0x1626, 0x1622, 0x1612, 0x162b,
                    }, MEQ, Local0, MTR, 0, 0))
                    {
                        Local2 = HASWELL_PWMMAX
                    }
                    Else
                    {
                        // assume Skylake/KabyLake/KabyLake-R, both 0x56c
                        // 0x1916, 0x191E, 0x1926, 0x1927, 0x1912, 0x1932, 0x1902, 0x1917, 0x191b,
                        // 0x5916, 0x5912, 0x591b, others...
                        Local2 = SKYLAKE_PWMMAX
                    }
                }
                INI1(Local4)
                // change/scale only if different than current...
                Local1 = ^LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (((^LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = ^P0BL, ^P0BL == Local7, ) { }
                    ^LEVX = Local0
                }
            }

            // Now Local2 is the new PWMMax, set _UID accordingly
            // The _UID selects the correct entry in AppleBacklightFixup.kext
            If (Local2 == SANDYIVY_PWMMAX) { _UID = 14 }
            ElseIf (Local2 == HASWELL_PWMMAX) { _UID = 15 }
            ElseIf (Local2 == SKYLAKE_PWMMAX) { _UID = 16 }
            ElseIf (Local2 == CUSTOM_PWMMAX_07a1) { _UID = 17 }
            ElseIf (Local2 == CUSTOM_PWMMAX_1499) { _UID = 18 }
            ElseIf (Local2 == COFFEELAKE_PWMMAX) { _UID = 19 }
            Else { _UID = 99 }
        }
    }

//
// Keyboard/Trackpad
//

    
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.LPCB.H_EC)
    {
        // _Q38 called on brightness up key
        Method (_Q38, 0, NotSerialized)  // _Qxx: EC Query
        {
            Notify (\_SB.PCI0.LPCB.PS2K, 0x10)
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0206)
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0286)
        }

        // _Q39 called on brightness down ke
        Method (_Q39, 0, NotSerialized)  // _Qxx: EC Query
        {
            Notify (\_SB.PCI0.LPCB.PS2K, 0x20)
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0205)
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0285)

        }
   }


// Battery Status
//

    // Override for ACPIBatteryManager.kext
    
     External (_SB_.PCI0.LPCB.H_EC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.ADDA, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.ADDH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.ADDL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.B1DI, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.B1IC, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BAT1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BAT1.POSW, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BATM, MutexObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BCNT, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BMIH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.BMIL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.DAVH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.DAVL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.E907, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.ECA2, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.FMVH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.FMVL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.HIDH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.HIDL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.SMAD, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.SMCM, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.SMPR, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.SMST, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.VPC0, DeviceObj)    // (from opcode)
    External (ADDA, IntObj)    // Warning: Unknown object
    External (ADDH, UnknownObj)    // Warning: Unknown object
    External (ADDL, UnknownObj)    // Warning: Unknown object
    External (B1DI, UnknownObj)    // Warning: Unknown object
    External (B1IC, UnknownObj)    // Warning: Unknown object
    External (BAT1, DeviceObj)    // Warning: Unknown object
    External (BATM, UnknownObj)    // Warning: Unknown object
    External (BCNT, UnknownObj)    // Warning: Unknown object
    External (BMIH, IntObj)    // Warning: Unknown object
    External (BMIL, IntObj)    // Warning: Unknown object
    External (DAVH, IntObj)    // Warning: Unknown object
    External (DAVL, IntObj)    // Warning: Unknown object
    External (E907, UnknownObj)    // Warning: Unknown object
    External (ECA2, IntObj)    // Warning: Unknown object
    External (FMVH, IntObj)    // Warning: Unknown object
    External (FMVL, IntObj)    // Warning: Unknown object
    External (HIDH, IntObj)    // Warning: Unknown object
    External (HIDL, IntObj)    // Warning: Unknown object
    External (POSW, IntObj)    // Warning: Unknown object
    External (SMAD, UnknownObj)    // Warning: Unknown object
    External (SMCM, UnknownObj)    // Warning: Unknown object
    External (SMPR, IntObj)    // Warning: Unknown object
    External (SMST, IntObj)    // Warning: Unknown object
    External (VPC0, DeviceObj)    // Warning: Unknown object

    Scope (\_SB.PCI0.LPCB.H_EC)
    {
        OperationRegion (XCF3, EmbeddedControl, Zero, 0xFF)
        Field (XCF3, ByteAcc, Lock, Preserve)
        {
            Offset (0x1C), 
            SMDX,   256, 
            Offset (0x60), 
            BC0H,   8, 
            BC1H,   8, 
            BC2H,   8, 
            BC3H,   8, 
            Offset (0x70), 
            BDT0,   8, 
            BDT1,   8, 
            Offset (0x74), 
            BCY0,   8, 
            BCY1,   8, 
            Offset (0x8F), 
            BXMA,   64, 
            Offset (0x98), 
            BYMA,   64, 
            Offset (0xAA), 
            RTP0,   8, 
            PTP1,   8, 
            B0ET,   8, 
            B1ET,   8, 
            Offset (0xB6), 
            BTM0,   8, 
            BTM1,   8, 
            B0PV,   8, 
            B1PV,   8, 
            Offset (0xC2), 
            BAC0,   8, 
            BAC1,   8, 
            BDC0,   8, 
            BDC1,   8, 
            BDV0,   8, 
            BDV1,   8, 
            Offset (0xCC), 
            BFC0,   8, 
            BFC1,   8, 
            Offset (0xD0), 
            BCR0,   8, 
            BCR1,   8
        }

        Scope (BAT1)
        {
            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                Name (BPKG, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "VIUU4", 
                    "BAT20101001", 
                    "LiP", 
                    "Lenovo IdeaPad"
                })
                Name (BPKH, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "VIUU4", 
                    "BAT20101001", 
                    "LION", 
                    "Lenovo IdeaPad"
                })
                Name (MDST, Buffer (0x05)
                {
                    "    "
                })
                Name (SNST, Buffer (0x05)
                {
                    "    "
                })
                Name (TPST, Buffer (0x05)
                {
                    "    "
                })
                Name (LENV, Buffer (0x09)
                {
                    "        "
                })
                If (ECA2)
                {
                    Store (B1B2 (BFC0, BFC1), Local0)
                    If (Local0)
                    {
                        Store (B1B2 (BDC0, BDC1), Index (BPKG, One))
                        Store (Local0, Index (BPKG, 0x02))
                        Store (B1B2 (BDV0, BDV1), Index (BPKG, 0x04))
                        Divide (Local0, 0x0A, Local1, Local2)
                        Store (Local2, Index (BPKG, 0x05))
                        Divide (Local0, 0x14, Local1, Local2)
                        Store (Local2, Index (BPKG, 0x06))
                        Store (B1B2 (BDC0, BDC1), Index (BPKH, One))
                        Store (Local0, Index (BPKH, 0x02))
                        Store (B1B2 (BDV0, BDV1), Index (BPKH, 0x04))
                        Divide (Local0, 0x0A, Local1, Local2)
                        Store (Local2, Index (BPKH, 0x05))
                        Divide (Local0, 0x14, Local1, Local2)
                        Store (Local2, Index (BPKH, 0x06))
                    }
                }

                If (LEqual (B1B4 (BC0H, BC1H, BC2H, BC3H), 0x0050694C))
                {
                    Return (BPKG)
                }
                Else
                {
                    Return (BPKH)
                }
            }

            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                Acquire (BATM, 0xFFFF)
                Name (PKG1, Package (0x04)
                {
                    Ones, 
                    Ones, 
                    Ones, 
                    Ones
                })
                If (ECA2)
                {
                    ShiftLeft (B1IC, One, Local0)
                    Or (B1DI, Local0, Local1)
                    Store (Local1, Index (PKG1, Zero))
                    Store (B1B2 (BCR0, BCR1), Local2)
                    Store (POSW (Local2), Local2)
                    Store (B1B2 (B0PV, B1PV), Local3)
                    Divide (Local3, 0x03E8, Local4, Local3)
                    Multiply (Local2, Local3, Local2)
                    Store (Local2, Index (PKG1, One))
                    Store (B1B2 (BAC0, BAC1), Index (PKG1, 0x02))
                    Store (B1B2 (B0PV, B1PV), Index (PKG1, 0x03))
                }

                Release (BATM)
                Return (PKG1)
            }
        }

        Scope (VPC0)
        {
            Method (MHPF, 1, NotSerialized)
            {
                Name (BFWB, Buffer (0x25) {})
                CreateByteField (BFWB, Zero, FB0)
                CreateByteField (BFWB, One, FB1)
                CreateByteField (BFWB, 0x02, FB2)
                CreateByteField (BFWB, 0x03, FB3)
                CreateField (BFWB, 0x20, 0x0100, FB4)
                CreateByteField (BFWB, 0x24, FB5)
                If (LLessEqual (SizeOf (Arg0), 0x25))
                {
                    If (LNotEqual (SMPR, Zero))
                    {
                        Store (SMST, FB1)
                    }
                    Else
                    {
                        Store (Arg0, BFWB)
                        Store (FB2, SMAD)
                        Store (FB3, SMCM)
                        Store (FB5, BCNT)
                        Store (FB0, Local0)
                        If (LEqual (And (Local0, One), Zero))
                        {
                            WECB (0x1C, 0x0100, FB4)
                        }

                        Store (FB0, SMPR)
                        Store (0x03E8, Local0)
                        While (SMPR)
                        {
                            Sleep (One)
                            Decrement (Local0)
                        }

                        Store (FB0, Local0)
                        If (LNotEqual (And (Local0, One), Zero))
                        {
                            Store (RECB (0x1C, 0x0100), FB4)
                        }

                        Store (SMST, FB1)
                    }

                    Return (BFWB)
                }
            }

            Method (SMTF, 1, NotSerialized)
            {
                If (LEqual (Arg0, Zero))
                {
                    Return (B1B2 (B0ET, B1ET))
                }

                If (LEqual (Arg0, One))
                {
                    Return (Zero)
                }

                Return (Zero)
            }

            Method (GSBI, 1, NotSerialized)
            {
                Name (BT11, Zero)
                Name (BTIF, Buffer (0x53) {})
                CreateWordField (BTIF, Zero, IFDC)
                CreateWordField (BTIF, 0x02, IFFC)
                CreateWordField (BTIF, 0x04, IFRC)
                CreateWordField (BTIF, 0x06, IFAT)
                CreateWordField (BTIF, 0x08, IFAF)
                CreateWordField (BTIF, 0x0A, IFVT)
                CreateWordField (BTIF, 0x0C, IFCR)
                CreateWordField (BTIF, 0x0E, IFTP)
                CreateWordField (BTIF, 0x10, IFMD)
                CreateWordField (BTIF, 0x12, IFFD)
                CreateWordField (BTIF, 0x14, IFDV)
                CreateField (BTIF, 0xB0, 0x50, IFCH)
                CreateField (BTIF, 0x0100, 0x40, IFDN)
                CreateField (BTIF, 0x0140, 0x60, IFMN)
                CreateField (BTIF, 0x01A0, 0xB8, IFBC)
                CreateField (BTIF, 0x0258, 0x40, IFBV)
                Store (Divide (B1B2 (BDC0, BDC1), 0x0A, ), IFDC)
                Store (Divide (B1B2 (BFC0, BFC1), 0x0A, ), IFFC)
                Store (Divide (B1B2 (BAC0, BAC1), 0x0A, ), IFRC)
                Store (B1B2 (RTP0, PTP1), IFAT)
                Store (B1B2 (B0ET, B1ET), IFAF)
                Store (B1B2 (B0PV, B1PV), IFVT)
                Store (B1B2 (BCR0, BCR1), IFCR)
                Store (B1B2 (BTM0, BTM1), IFTP)
                Store (B1B2 (BDT0, BDT1), IFMD)
                Store (B1B2 (BDT0, BDT1), IFFD)
                Store (B1B2 (BDV0, BDV1), IFDV)
                Store (Zero, IFCH)
                Store (B1B4 (BC0H, BC1H, BC2H, BC3H), IFCH)
                Store (Zero, IFDN)
                Store (RECB (0x98, 0x40), IFDN)
                Store (Zero, IFMN)
                Store (RECB (0x8F, 0x40), IFMN)
                Store (Zero, IFBC)
                Store (0x17, BT11)
                While (BT11)
                {
                    Store (0x08, ADDH)
                    Store (Add (0x41, BT11), ADDL)
                    Sleep (0x02)
                    Store (ADDA, Index (BTIF, Add (0x33, BT11)))
                    Decrement (BT11)
                }

                Store (Zero, IFBV)
                Store (BMIL, Index (BTIF, 0x4B))
                Store (BMIH, Index (BTIF, 0x4C))
                Store (HIDL, Index (BTIF, 0x4D))
                Store (HIDH, Index (BTIF, 0x4E))
                Store (FMVL, Index (BTIF, 0x4F))
                Store (FMVH, Index (BTIF, 0x50))
                Store (DAVL, Index (BTIF, 0x51))
                Store (DAVH, Index (BTIF, 0x52))
                Store (BTIF, E907)
                Return (BTIF)
            }

            Method (GBID, 0, Serialized)
            {
                Name (GBUF, Package (0x04)
                {
                    Buffer (0x02)
                    {
                         0x00, 0x00                                     
                    }, 

                    Buffer (0x02)
                    {
                         0x00, 0x00                                     
                    }, 

                    Buffer (0x08)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    Buffer (0x08)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }
                })
                Store (B1B2 (BCY0, BCY1), Index (DerefOf (Index (GBUF, Zero)), Zero))
                Store (Zero, Index (DerefOf (Index (GBUF, One)), Zero))
                Store (BMIL, Index (DerefOf (Index (GBUF, 0x02)), Zero))
                Store (BMIH, Index (DerefOf (Index (GBUF, 0x02)), One))
                Store (HIDL, Index (DerefOf (Index (GBUF, 0x02)), 0x02))
                Store (HIDH, Index (DerefOf (Index (GBUF, 0x02)), 0x03))
                Store (FMVL, Index (DerefOf (Index (GBUF, 0x02)), 0x04))
                Store (FMVH, Index (DerefOf (Index (GBUF, 0x02)), 0x05))
                Store (DAVL, Index (DerefOf (Index (GBUF, 0x02)), 0x06))
                Store (DAVH, Index (DerefOf (Index (GBUF, 0x02)), 0x07))
                Store (Zero, Index (DerefOf (Index (GBUF, 0x03)), Zero))
                Return (GBUF)
            }
        }

        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE)
        }

        Method (RECB, 2, Serialized)
        {
            ShiftRight (Arg1, 0x03, Arg1)
            Name (TEMP, Buffer (Arg1) {})
            Add (Arg0, Arg1, Arg1)
            Store (Zero, Local0)
            While (LLess (Arg0, Arg1))
            {
                Store (RE1B (Arg0), Index (TEMP, Local0))
                Increment (Arg0)
                Increment (Local0)
            }

            Return (TEMP)
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Store (Arg1, BYTE)
        }

        Method (WECB, 3, Serialized)
        {
            ShiftRight (Arg1, 0x03, Arg1)
            Name (TEMP, Buffer (Arg1) {})
            Store (Arg2, TEMP)
            Add (Arg0, Arg1, Arg1)
            Store (Zero, Local0)
            While (LLess (Arg0, Arg1))
            {
                WE1B (Arg0, DerefOf (Index (TEMP, Local0)))
                Increment (Arg0)
                Increment (Local0)
            }
        }
    }

    Method (B1B2, 2, NotSerialized)
    {
        Return (Or (Arg0, ShiftLeft (Arg1, 0x08)))
    }

    Method (B1B4, 4, NotSerialized)
    {
        Store (Arg3, Local0)
        Or (Arg2, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg1, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg0, ShiftLeft (Local0, 0x08), Local0)
        Return (Local0)
    }
}

//EOF
