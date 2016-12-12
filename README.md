# 545 Melons - Sega Genesis Project

This repository shows our progress we have made in emulating the Sega Genesis. It is incomplete as described in our final design report, but our demo involving a trivial VDP display and the PSG playing Tetris can be accessed by the VDP folder's project file and synthesizing that.

Every separate component is implemented via different folders, in which we implemented the DMA, ROM, and TI chip. We took the M68k, VDP, and Z80 from online sources. The YM2612 is a physical chip that we attempted interfacing with but haven't succeeded.
The top file (SegaGenesis.sv) indicates our integration efforts that also did not succeed.