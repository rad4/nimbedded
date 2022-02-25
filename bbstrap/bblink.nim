import volatile, bitops
## *
##  @brief Reset and Clock Control
##

type
  RCC_TypeDef*   = object # pg 166, clock diagram 127
    CR*: uint32     ## !< RCC clock control register, Add offset: 0x00
    CFGR*: uint32  ## !< RCC clock configuration register, Add offset: 0x04
    CIR*: uint32   ## !< RCC clock interrupt register,        Add offset: 0x08
    APB2RSTR*: uint32   ## !< RCC APB2 peripheral reset register,  offset: 0x0C
    APB1RSTR*: uint32   ## !< RCC APB1 peripheral reset register,  offset: 0x10
    AHBENR*: uint32     ## !< RCC AHB peripheral clock register,   offset: 0x14
    APB2ENR*: uint32    ## !< RCC APB2 peripheral clock enable reg offset: 0x18
    APB1ENR*: uint32    ## !< RCC APB1 peripheral clock enable reg offset: 0x1C
    BDCR*: uint32       ## !< RCC Backup domain control register,  offset: 0x20
    CSR*: uint32        ## !< RCC clock control & status register, offset: 0x24
    AHBRSTR*: uint32    ## !< RCC AHB peripheral reset register,   offset: 0x28
    CFGR2*: uint32      ## !< RCC clock configuration register 2,  offset: 0x2C
    CFGR3*: uint32      ## !< RCC clock configuration register 3,  offset: 0x30


type
  GPIO_TypeDef*   = object # pg 243
    MODER*: uint32  ## !< GPIO port mode register,               Address offset: 0x00
    OTYPER*: uint32 ## !< GPIO port output type register,        Address offset: 0x04
    OSPEEDR*: uint32## !< GPIO port output speed register,       Address offset: 0x08
    PUPDR*: uint32  ## !< GPIO port pull-up/pull-down register,  Address offset: 0x0C
    IDR*: uint32    ## !< GPIO port input data register,         Address offset: 0x10
    ODR*: uint32    ## !< GPIO port output data register,        Address offset: 0x14
    BSRR*: uint32   ## !< GPIO port bit set/reset register,      Address offset: 0x1A
    LCKR*: uint32   ## !< GPIO port configuration lock register, Address offset: 0x1C
    #AFR*: array[2, uint32] deviation      ## !< GPIO alternate function registers,
    AFRL*:  uint32  # !< GPIO alternate furm registers,   Address offset: 0x20
    AFRH*:  uint32  # !< GPIO alternate funcregisters,     Address offset: 0x24
    BRR*: uint32    # !< GPIO bit reset register,               Address offset: 0x28

## !< Peripheral memory map  pg 57 RM

const
  PERIPH_BASE* = 0x40000000
  APB1PERIPH_BASE* = PERIPH_BASE
  APB2PERIPH_BASE* = (PERIPH_BASE + 0x00010000)
  AHB1PERIPH_BASE* = (PERIPH_BASE + 0x00020000)
  AHB2PERIPH_BASE* = (PERIPH_BASE + 0x08000000)
  AHB3PERIPH_BASE* = (PERIPH_BASE + 0x10000000)
  RCC_BASE* = (AHB1PERIPH_BASE + 0x00001000)
  GPIOA_BASE* = (AHB2PERIPH_BASE + 0x00000000)
  
  GPIOA* = (cast[ptr GPIO_TypeDef](GPIOA_BASE))
  RCC* = (cast[ptr RCC_TypeDef](RCC_BASE))

  GPIOAEN : uint32 = 1 shl 17

template st*[T: SomeInteger, U: SomeInteger](reg:T, val: U) =
  volatileStore(reg.addr, cast[T](val))

template ld*[T: SomeInteger](reg: T): T =
  volatileLoad(reg.addr)

template bclrmask*[T, U: SomeInteger](reg: T, mask : U) =
  reg.st reg.ld and not cast[T](mask)

template bsetmask*[T, U: SomeInteger](reg: T, mask: U) =
  reg.st reg.ld or cast[T](mask)

template btoggle*[T, U: SomeInteger](reg: T, bit: U) =
  reg.st (reg.ld xor cast[T](1 shl bit))

  
proc initLed  =
  #enable porta on  clock
  RCC.AHBENR.bsetmask GPIOAEN   # pg 148
 # set port a pin 5 as output
  GPIOA.MODER.bsetmask (1 shl 10)  # RM pg 237
  GPIOA.MODER.bclrmask (1 shl 11)

proc go {.noreturn.}  =
  var i {.volatile.} = 47000  # volatile to keep delay loop
  while true:
   while i!=0:
       i = i - 1  
   i = 64000
   GPIOA.ODR.btoggle 5 # 239

initLed()
go()
