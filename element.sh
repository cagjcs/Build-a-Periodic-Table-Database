#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
else
  INPUT=$1
  # ¿Es numérico?
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
  # ¿es el símbolo atómico o el nombre?
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
  fi
fi

if [[ -z $ATOMIC_NUMBER ]]; then 
  echo "I could not find that element in the database."
  exit
else
	RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
	echo $RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE_ID
	do 
   	# preparar los datos para imprimir
	  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  	ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/^ *| *$//g'); 
  	NAME=$(echo $NAME | sed 's/^ *| *$//g'); 
  	SYMBOL=$(echo $SYMBOL | sed 's/^ *| *$//g'); 
  	TYPE=$(echo $TYPE | sed 's/^ *| *$//g'); 
  	ATOMIC_MASS=$(echo $ATOMIC_MASS | sed 's/^ *| *$//g'); 
  	MELTING_POINT_CELSIUS=$(echo $MELTING_POINT_CELSIUS | sed 's/^ *| *$//g'); 
  	BOILING_POINT_CELSIUS=$(echo $BOILING_POINT_CELSIUS | sed 's/^ *| *$//g'); 

  	echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi	
