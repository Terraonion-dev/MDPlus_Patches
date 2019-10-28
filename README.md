# MDPlus_Patches
MD+ patches sources

This repository includes the source code for some MD+ patches used to add CDDA audio to Megadrive/Genesis games through the MegaSD cartridge.

It also includes our own simple patching tool that allows creating human readable patches for the ROMs.

To build the patches, you'll need [SGDK](https://github.com/Stephane-D/SGDK) and update the mk.bat files in each directory to point to your SGDK base directory. Only *as* and *objcopy* are used. A prebuilt executable of the patching tool is also included. Also, no roms are included so you need to place the proper ROM (see each mk.bat file) on each game directory.

# TOPatcher usage
Along with the patches, a patcher tool is included. We used it to create the original patched and are sharing it here for everyone use.
It's a very simple patching tool, but it allows human readable patches to be created, and easily edited.

### Command line

    ToPatcher -patch patchfile originalfile patchedfile
Applies the patches contained in *patchfile* to the file *originalfile* creating *patchedfile*


    ToPatcher -createIPS patchfile ipsfile
Creates an IPS file named *ipsfile* with the patches contained in *patchfile*


### Patchfile structure
The patch file is a text file, generally named *patch.to* that includes the commands to patch or inject files at specific addresses.

The only lines that are processed by the patcher tool are the ones starting with @. All values are specified in hexadecimal. There are currently only 2 recognized commands:

- @*address* *originalbytes* **->** *patchbytes* . Patch a string of bytes starting at the specified address. TOPatcher will check that the ROM bytes are either the original or the patched ones. If they aren't it will fail and exit without patching anything. The length of the original bytes must match the length of the patch bytes.
- @*address* **Inject** *filename* . Inject the contents of the specified file into the rom, starting at the specified address.

Example of strider patch

    # Skip CRC check
    @348 6600007C -> 4E714E71

    # capture command enqueue request
    # subi.b  #$81,d0  bcs   B05FC -> jmp $FF000 nop
    @B0790 040000816500FE66 -> 4EF9000FF0004E71
    
    # move.b  #$2B,d0 move.b  #$80,d1 -> jsr $FF00C  nop
    @B08CE 103C002B123C0080 -> 4EB9000FF00C4E71

    #Inject the additional code at the end of the rom
    @FF000 Inject patch.bin

This code will perform 3 patches, at addresses 348h, B0790h and B08CEh, and then it will inject the patch.bin file to address FF000h.
The rest of the lines are just comments. We generally use # to signal it's a comment, but anything that doesn't start with @ is ignored by the parser.
