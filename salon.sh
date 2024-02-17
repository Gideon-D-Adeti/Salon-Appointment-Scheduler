#!/bin/bash

# Define PSQL command
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# Welcome message
echo -e "\n~~~~~ Welcome to GDA's Salon ~~~~~\n"

DISPLAY_INFO() {
  # Display argument in red color
  if [[ $1 ]]; then
    echo -e "\e[31m$1\e[0m"
  fi

  # Call the DISPLAY_SERVICES function to display available services
  DISPLAY_SERVICES
}

DISPLAY_SERVICES() {
  # Display numbered list of services
  echo -e "\nHere are the available services:"
  $PSQL "SELECT service_id, name FROM services" | while IFS='|' read -r SERVICE_ID SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # Prompt for service selection
  echo -e "\nEnter the number of the service you'd like: "
  read SERVICE_ID_SELECTED

  # Validate service selection
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] ; then
    DISPLAY_INFO "That is not a valid service number."
  else
    case $SERVICE_ID_SELECTED in
      1)
        echo -e "\nYou've chosen a \e[32mhaircut\e[0m. Our skilled stylists will give you the perfect cut!"
        ;;
      2)
        echo -e "\nYou've chosen a \e[32mhair coloring\e[0m service. Get ready for a vibrant new look!"
        ;;
      3)
        echo -e "\nYou've chosen a \e[32mmanicure\e[0m service. Treat yourself to perfectly manicured nails!"
        ;;
      4)
        echo -e "\nYou've chosen a \e[32mpedicure\e[0m service. Relax and pamper your feet with our pedicure treatment!"
        ;;
      5)
        echo -e "\nYou've chosen a \e[32mhair styling\e[0m service. Get ready to dazzle with a stunning new hairstyle!"
        ;;
      6)
        echo -e "\nYou've chosen an \e[32meyebrow shaping\e[0m service. Enhance your look with perfectly shaped eyebrows!"
        ;;
      7)
        echo -e "\nYou've chosen a \e[32mwaxing\e[0m service. Experience smooth and hair-free skin with our waxing treatment!"
        ;;
      8)
        echo -e "\nYou've chosen a \e[32mfacial\e[0m service. Indulge in a rejuvenating facial to refresh your skin!"
        ;;
      9)
        echo -e "\nYou've chosen a \e[32mmassage therapy\e[0m service. Relieve stress and tension with our relaxing massage!"
        ;;
      10)
        echo -e "\nYou've chosen a \e[32mmakeup application\e[0m service. Let our experts enhance your natural beauty with professional makeup!"
        ;;
      *)
        DISPLAY_INFO "Sorry, the selected service is not available. Please choose a valid service number."
        ;;
    esac
  fi
  # Get name of customer
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Check if customer exists
  CUSTOMER_EXISTS=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  if [[ -z $CUSTOMER_EXISTS ]] ; then
    # Customer doesn't exist
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer
    CUSTOMER_INSERTION_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
    # Customer does exist
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  # Get the service name selected
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # Set the service name selected with the first character in lowercase
  SERVICE_NAME_SELECTED="${SERVICE_NAME_SELECTED,}"

  # Prompt customer for appointment time
  echo -e "\nWhat time would you like your $SERVICE_NAME_SELECTED, $CUSTOMER_NAME? (e.g., 10:30 AM):"
  read SERVICE_TIME

  # Insert appointment
  APPOINTMENT_INSERTION_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ((SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'), $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # Display confirmation message
  echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

# Call the function to start the program
DISPLAY_INFO
