
DefinitionBlock ("", "SSDT", 2, "15isk", "BATT", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.ADDA, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.ADDH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.ADDL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.B1DI, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.B1IC, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.BAT1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.BAT1.POSW, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LPCB.EC.BATM, MutexObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.BCNT, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.BMIH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.BMIL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.DAVH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.DAVL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.E907, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.ECA2, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.FMVH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.FMVL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.HIDH, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.HIDL, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.SMAD, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.SMCM, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.SMPR, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.SMST, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC.VPC0, DeviceObj)    // (from opcode)
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

    Scope (\_SB.PCI0.LPCB.EC)
    {
        OperationRegion (XCF3, EmbeddedControl, Zero, 0xFF)
        Field (XCF3, ByteAcc, Lock, Preserve)
        {
            Offset (0x1C), 
            SMDX,   256, //SMD0,   256, 
            Offset (0x60), 
            BC0H,   8, //B1CH,   32,0x61
            BC1H,   8, //B1CH,   32,0x62
            BC2H,   8, //B1CH,   32,0x63
            BC3H,   8, //B1CH,   32,0x64
            //B2CH,   32, 0x68
            //B1MO,   16, 0x6a
            //B2MO,   16, 0x6c
            //B1SN,   16, 0x6e
            //B2SN,   16, 0x70
            Offset (0x70), 
            BDT0,   8, //B1DT,   16, 0x71
            BDT1,   8, //B1DT,   16, 0x72
           
            //B2DT,   16, 0x74
            Offset (0x74), 
            BCY0,   8, //B1CY,   16, 
            BCY1,   8, //B1CY,   16, 
            //....
            Offset (0x8F), 
            BXMA,   64, //B1MA,   64,
            Offset (0x98), 
            BYMA,   64, //B2MA,   64,
            Offset (0xAA), 
            RTP0,   8,  //RTEP,   16, 
            PTP1,   8, //RTEP,   16, 
            B0ET,   8, //BET2,   16,
            B1ET,   8, //BET2,   16,
            Offset (0xB6), 
            BTM0,   8, //B1TM,   16,
            BTM1,   8, //B1TM,   16,
            B0PV,   8, //BAPV,   16,
            B1PV,   8, //BAPV,   16,
            Offset (0xC2), 
            BAC0,   8, //BARC,   16,0xC3
            BAC1,   8, //BARC,   16,0xC4
            BDC0,   8, //BADC,   16,0xC5
            BDC1,   8, //BADC,   16,0xC6
            BDV0,   8, //BADV,   16,0xC7
            BDV1,   8, //BADV,   16,0xC8
            //BDCW,   16, 0xCa
            //BDCL,   16,0xCc
            Offset (0xCC), 
            BFC0,   8, //BAFC,   16,0xCD
            BFC1,   8, //BAFC,   16,0xCE
            //BAPR,   16,0xD0
            Offset (0xD0), 
            BCR0,   8,  //B1CR,   16,
            BCR1,   8 //B1CR,   16,
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

