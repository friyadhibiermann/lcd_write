#!/bin/sh
# 2016 :p raphik
# Comando para LCD HD44780 + expansor I2C PCF8574T
# Sintaxis: lcd_write <línea> <texto>
#
func_init() # inicializar display
{
func_LCD I 0x33; func_LCD I 0x32; func_LCD I 0x28; func_LCD I 0x0C; func_LCD I 0x01
}

func_LCD()
{
  local nibb; local data
  if [ $1 == "I" ]; then
    data=$2
    nibb=$(($data/0x10*0x10)); i2cset -y $BUS $ADDRESS $(($nibb+$INST_SET)) $(($nibb+$INST_SEND))
    nibb=$(($data%0x10*0x10)); i2cset -y $BUS $ADDRESS $(($nibb+$INST_SET)) $(($nibb+$INST_SEND))
  fi
  if [ $1 == "C" ]; then
    data=$(printf "0x%02x" "'$2")
    nibb=$(($data/0x10*0x10)); i2cset -y $BUS $ADDRESS $(($nibb+$CHAR_SET)) $(($nibb+$CHAR_SEND))
    nibb=$(($data%0x10*0x10)); i2cset -y $BUS $ADDRESS $(($nibb+$CHAR_SET)) $(($nibb+$CHAR_SEND))
  fi
}

func_row_col()
{
  func_LCD I $((0x80+0x40*$1+$2))
}

func_print_string() # escribir una cadena
{
  local i=0
  while [ $i -lt ${#1} ]; do
    func_LCD C "${1:$i:1}"
    let i++
  done
}

# SCRIPT
if [ "$#" -eq 0 ]; then
  printf "\n  lcd_write ver. 1.0 2016 :p raphik\n  Sintaxis: lcd_write <línea> <texto>\n\n"
  return
fi

  BUS=0
  ADDRESS=0x3F
  INST_SET=0x0C
  INST_SEND=0x08
  CHAR_SET=0x0D
  CHAR_SEND=0x09

if [ $1 == "init" ]; then 
  func_init
  return
fi

func_row_col $1 $2
func_print_string "$3"
return
# SCRIPT
