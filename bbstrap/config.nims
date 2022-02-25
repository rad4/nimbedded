task comp, "Compile project":
  switch("os","any")
  switch("cpu","arm")
  switch("arm.any.gcc.exe", "arm-none-eabi-gcc")
  switch("arm.any.gcc.linkerexe", "arm-none-eabi-gcc")
  switch("passC", "-mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32 -DSTM32F3 -DDEBUG -DSTM32F303RETx -DNUCLEO_F303RE -c -I../Inc -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb")
  switch("nimcache", "./ccode")
  switch("define", "useMalloc")
  switch("gc","none")
  switch("assertions","off")
  switch("stackTrace","off")
  switch("lineTrace","off")
  switch("noLinking","on")
  setCommand "c"

task link, "Link our object file":
   let
     binfile = "blinkynimR2"
     targetdir = "/home/rad/nimbedded/blinkynim/Debug/"

   echo gorge("arm-none-eabi-gcc -o \"" & binfile & ".elf\" @\"objects2.lst\"   -mcpu=cortex-m4 -T\"STM32F303RETX_FLASH.ld\" --specs=nosys.specs -Wl,-Map=" & binfile & ".map -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group")  

   exec "cp " & binfile & ".elf " & " " & targetdir
   exec "cp " & binfile & ".map " & " " & targetdir

   echo "generate hex and elf then copy"
   exec "arm-none-eabi-objcopy  -O ihex  " & binfile & ".elf  \"" & binfile & ".hex\""

   echo gorge("/home/rad/STM32Toolchain/STM32CubeProgrammer/bin/STM32_Programmer_CLI -c port=SWD  -w " & binfile & ".hex -g")
   
#[   
arm-none-eabi-gcc -o "blinkynim.elf" @"objects.list"   -mcpu=cortex-m4 -T"/home/rad/nimbedded/blinkynim/STM32F303RETX_FLASH.ld" --specs=nosys.specs -Wl,-Map="blinkynim.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
Finished building target: blinkynim.elf
 
  arm-none-eabi-size   blinkynim.elf 
arm-none-eabi-objdump -h -S  blinkynim.elf  > "blinkynim.list"
   text	   data	    bss	    dec	    hex	filename
    656	      8	   1568	   2232	    8b8	blinkynim.elf
arm-none-eabi-objcopy  -O binary  blinkynim.elf  "blinkynim.bin"
]#
