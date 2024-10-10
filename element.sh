#!/bin/bash

# Define the PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Input argument
INPUT=$1

# Query the database for the element based on atomic_number, symbol, or name
ELEMENT_INFO=$($PSQL "
SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
FROM elements
JOIN properties ON elements.atomic_number = properties.atomic_number
JOIN types ON properties.type_id = types.type_id
WHERE elements.atomic_number::text = '$INPUT'
   OR elements.symbol = '$INPUT'
   OR elements.name = '$INPUT';")

# If no element was found
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
else
  # Parse the query result
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"
  
  # Output the formatted information about the element
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
