
DefinitionBlock ("", "SSDT", 2, "i5isk", "PRW", 0x00000000)
{
    External (XPRW, MethodObj)    // 2 Arguments (from opcode)

    Method (GPRW, 2, NotSerialized)
    {
        If (LEqual (0x6D, Arg0))
        {
            Return (Package (0x02)
            {
                0x6D, 
                Zero
            })
        }

        If (LEqual (0x0D, Arg0))
        {
            Return (Package (0x02)
            {
                0x0D, 
                Zero
            })
        }

        Return (XPRW (Arg0, Arg1))
    }
}

