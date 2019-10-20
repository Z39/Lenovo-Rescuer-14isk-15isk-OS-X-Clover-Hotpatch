EC// Replace Q38 & Q39 key functions for brightness
DefinitionBlock ("", "SSDT", 2, "15isk", "FN", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.LPCB.EC)
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
}

