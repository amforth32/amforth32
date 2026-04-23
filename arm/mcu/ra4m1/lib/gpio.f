-int

\ PCNTR1 PODR PDR
\ 00..15 direction 0 input 1 ouput PDR
\ 16..31 output 0 low 1 high PODR

\ Port Control Register 2 (PCNTR2/EIDR/PIDR)
\ PIDRn bits (Pmn State)

\ EIDRn bits (Port Event Input Data)

\  Address(es):
\ Port mn Pin Function Select Register (PmnPFS/PmnPFS_HA/PmnPFS_BY) (m = 0 to 9; n = 00 to 15)

\ 19.2.6 Write-Protect Register (PWPR)
\ clear BOWI set PFSWE

\ D7 is P112

\ PORT0.PCNTR140040000h
\ PORT1.PCNTR140040020h
\ PFS.P100PFS 4004 0840h to PFS.P115PFS 4004 087C





\ # 19.2.5 Port mn Pin Function Select Register (PmnPFS/PmnPFS_HA/PmnPFS_BY) (m = 0 to 9; n = 00 to 15)
\ # PFS.P100PFS 4004 0840h to PFS.P115PFS 4004 087Ch (32-bits)
\ .equ RA4_P102PFS, 0x40040848
\ # BITS:
\ # [0]  PODR   Port Output Data
\ # [1]  PIDR.  Port Input Data/State
\ # [2]  PDR.   Port Direction: 0 = Input / 1 = Output


\ $40040D03 constant RA4_PWPR
\ $40040870 constant RA4_112 

\ : on  %110 RA4_112 mset ;
\ : off %010 RA4_112 mclr ;

\ : unlock ( -- )
\     RA4_PWPR c@ %01 invert and RA4_PWPR c!
\     RA4_PWPR c@ %10 or RA4_PWPR c!
\     off
\ ;


\ \ need mask a --  !
\ \ need mask a -- ~!

\ : ~! 2+ ! ;
 
\ https://github.com/adafruit/Adafruit-GFX-Library/blob/master/glcdfont.c
\ from above 5x7 font adjusted to be a 6x8 font ( 1 << and trailing col)

\ Procedure for Specifying the Pin Functions
\ To specify the I/O pin functions:
\ 1. Clear the B0WI bit in the PWPR register. This enables writing to the PFSWE bit in the PWPR register.
\ 2. Set 1 to the PFSWE bit in the PWPR register. This enables writing to the PmnPFS register.
\ 3. Clear the Port Mode Control bit in the PMR for the target pin to select the general I/O port.
\ 4. Specify the input/output function for the pin through the PSEL[4:0] bit settings in the PmnPFS register.
\ 5. Set the PMR to 1 as required to switch to the selected input/output function for the pin.
\ 6. Clear the PFSWE bit in the PWPR register. This disables writing to the PmnPFS register.
\ 7. Set 1 to the B0WI bit in the PWPR register. This disables writing to the PFSWE bit in the PWPR register.

\ ======================================================================
\ GPIO 
\ ======================================================================

\ ENCODED
\ 32 bit
\ 0:3 Pin# n 4:7 Port# N 8:31 ASCII of Nnn 

create gpio
\ ENCODED         PFS      PCNRT1    MASK   
$31303331 , $400408CC , $40040068 , $0002 , \ D00 P301 UART SCI2 RX
$32303332 , $400408D0 , $40040068 , $0004 , \ D01 P302 UART SCI2 TX
$34303114 , $40040850 , $40040028 , $0010 , \ D02 P104 GPIO
$35303115 , $40040854 , $40040028 , $0020 , \ D03 P105 PWM GPT2
$36303116 , $40040858 , $40040028 , $0040 , \ D04 P106 CAN TX
$37303117 , $4004085C , $40040028 , $0080 , \ D05 P107 PWM CAN RX
$31313111 , $4004086C , $40040028 , $0800 , \ D06 P111 PWM GPT3
$32313112 , $40040870 , $40040028 , $1000 , \ D07 P112 GPIO
$34303334 , $400408D8 , $40040068 , $0010 , \ D08 P304 GPIO
$33303333 , $400408D4 , $40040068 , $0008 , \ D09 P303 PWM GPT7
$33303113 , $4004084C , $40040028 , $0008 , \ D10 P103 PWM SPI SS
$31313444 , $4004092C , $40040088 , $0800 , \ D11 P411 PWM SPI MOSI
$30313443 , $40040928 , $40040088 , $0400 , \ D12 P410 SPI MISO
$32313445 , $40040930 , $40040088 , $1000 , \ D13 P412 SPI SCK LED
$34313040 , $40040838 , $40040008 , $4000 , \ A00 P014 ADC DAC
$30303000 , $40040800 , $40040008 , $0001 , \ A01 P000 ADC OPAMP+
$31303001 , $40040804 , $40040008 , $0002 , \ A02 P001 ADC OPAMP-
$32303002 , $40040808 , $40040008 , $0004 , \ A03 P002 ADC OPAMP out
$31303111 , $40040844 , $40040028 , $0002 , \ A04 P101 ADC I2C SDA
$30303110 , $40040840 , $40040028 , $0001 , \ A05 P100 ADC I2C SCL
$33303003 , $4004080C , $40040008 , $0008 , \ M00 P003 PLXLED
$34303004 , $40040810 , $40040008 , $0010 , \ M01 P004 PLXLED
$31313001 , $4004082C , $40040008 , $0800 , \ M02 P011 PLXLED
$32313002 , $40040830 , $40040008 , $1000 , \ M03 P012 PLXLED
$33313003 , $40040834 , $40040008 , $2000 , \ M04 P013 PLXLED
$35313005 , $4004083C , $40040008 , $8000 , \ M05 P015 PLXLED
$34303224 , $40040890 , $40040048 , $0010 , \ M06 P204 PLXLED
$35303225 , $40040894 , $40040048 , $0020 , \ M07 P205 PLXLED
$36303226 , $40040898 , $40040048 , $0040 , \ M08 P206 PLXLED
$32313222 , $400408B0 , $40040048 , $1000 , \ M09 P212 PLXLED
$33313223 , $400408B4 , $40040048 , $2000 , \ M10 P213 PLXLED

: gpio.str  ( n -- ) 4 * 0 + cells gpio + 1+ 3 ;
: gpio.pfs  ( n -- ) 4 * 1 + cells gpio + @ ;
: gpio.porr ( n -- ) 4 * 2 + cells gpio + @ ;
: gpio.posr ( n -- ) gpio.porr 2+ ; 
: gpio.mask ( n -- ) 4 * 3 + cells gpio + @ ;

: gpio.show ( -- )
    30 0 do
        i 2 u.r space [char] P emit i gpio.str type
        space i gpio.pfs @ r.. cr
    loop
;

\ PoP set D6 high/low 
\ Many different ways to do this

: D06+ [ 6 gpio.mask ] literal [ 6 gpio.posr ] literal h! ;
: D06- [ 6 gpio.mask ] literal [ 6 gpio.porr ] literal h! ;

: D07+ [ 7 gpio.mask ] literal [ 7 gpio.posr ] literal h! ;
: D07- [ 7 gpio.mask ] literal [ 7 gpio.porr ] literal h! ;

\ PoP set D6 as output 
\ need pfs.unlock first, but led-init unlocks in applturnkey

\ : ~D06 1 #14 lshift [ 6 gpio.pfs ] literal ! ;
: D06~ %100 [ 6 gpio.pfs ] literal ! ;
: D07~ %100 [ 7 gpio.pfs ] literal ! ;

\ There is always synonym / alias 

  


\ $40006300 constant IELSR0
\ $40006004 constant IRQCR4
\ $E000E100 constant NVIC.ISER0

\ : irq4.isr
\     IELSR0 @ 1 16 lshift invert and IELSR0 !   \ clear IR bit 16 only
\     led? if led-off else led-on then
\ ;i

\ : irq4.init
\     $05 IELSR0 !              \ map IRQ4 event 0x05 to NVIC slot 0
\     $00 IRQCR4 c!             \ falling edge
\     $01 NVIC.ISER0 !          \ enable NVIC slot 0
\     ['] irq4.isr 16 trap!     \ install Forth handler at vector 16
\ ;

