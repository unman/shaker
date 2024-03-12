#!/bin/bash
target_file=/home/user/.muttrc

if grep -q "##CONFIGURED" "$target_file" ; then
  zenity --question  --text="Mutt is already configured\nDo you want to change configuration?" --no-wrap
  if [ $? = 1 ];then
    exit
  else
    configured=1
  fi
fi

zenity --question --text="Do you have the details of your mail server ready?"
if [ $? = 0 ] ;then

  type="$(zenity --list --title="Connection type" --text="Select the connection type" --radiolist --column=Selection --column="Connection Type" \
  FALSE "POP3" FALSE "IMAP" )"
  if [ $? = 1 ]; then
    exit
  fi
  if [ "x$type" == "x" ]; then
    zenity --warning  --text="No connection type selected" --no-wrap
    exit
  fi

  zenity --info  --text="Now you need to enter the details of your mail server.\nIf you leave the password blank you will be prompted for it each time you connect." --no-wrap
  details="$(zenity --forms --title='Log in details' \
                   --text='Enter information about your email server' \
                   --add-entry='Server address' \
                   --add-entry='Server port' \
                   --add-entry='Username' \
                   --add-password='Password' )"
  if [ $? = 1 ]; then
    exit
  fi
  if [[ $details =~ "||" ]]; then
    zenity --warning  --text="Missing information"
    exit
  fi

  zenity --info  --text="Now you need to enter the details of your SMTP server.\nIf you leave the password blank you will be prompted for it each time you send mail." --no-wrap
  smtp_details="$(zenity --forms --title='Log in details' \
                   --text='Enter information about your SMTP server' \
                   --add-entry='Name on outgoing emails' \
                   --add-entry='Email address' \
                   --add-entry='Server address' \
                   --add-entry='Server port' \
                   --add-entry='Username' \
                   --add-password='Password' )"
  if [ $? = 1 ]; then
    exit
  fi
  if [[ $smtp_details =~ "||" ]]; then
    zenity --warning  --text="Missing information"
    exit
  fi
  oldifs=$IFS
  IFS='|' read -r server_address server_port name pw <<<$details
  IFS='|' read -r smtp_outname email smtp_address smtp_port smtp_name smtp_pw <<<$smtp_details
  IFS=$oldifs
  if [ $type == "POP3" ]; then
    type=POP
  fi
  if [ "x$pw" != "x" ]; then
    sed -i -E "/$type/,/END $type/  s^(set ${type,,}_pass).*^\1=$pw^ " $target_file 
  else
    sed -i -E "/$type/,/END $type/  s^(set ${type,,}_pass).*^#\1=^ " $target_file 
  fi
  sed -i -E -e "/USER CONFIGURATION/,/END USER CONFIGURATION/  s/^([^#])/#\1/ " \
            -e "/$type/,/END $type/  { //! s/^#// }" \
            -e "/$type/,/END $type/  s^(set folder.*\/\/).*^\1$server_address:$server_port/^ " \
            -e "/$type/,/END $type/  s^(set pop_host.*\/\/).*^\1$server_address:$server_port^ " \
            -e "/$type/,/END $type/  s^(set ${type,,}_user).*^\1=$name^ " $target_file 

  sed -i -E -e "/SMTP/,/END SMTP/  { //! s/^#// }" \
            -e "/SMTP/,/END SMTP/  s^(set my_user=).*^\1$smtp_name^ " \
            -e "/SMTP/,/END SMTP/  s^(set smtp_url.*\/\/).*^\1\$my_user@$smtp_address:$smtp_port^ " \
            -e "/SMTP/,/END SMTP/  s^(set realname=).*^\1$smtp_outname^ " \
            -e "/SMTP/,/END SMTP/  s^(set from=).*^\1$email^ " $target_file 
  if [ "x$smtp_pw" != "x" ]; then
    sed -i -E "/SMTP/,/END SMTP/  s^(set smtp_pass=).*^\1$smtp_pw^ " $target_file 
  else
    sed -i -E "/SMTP/,/END SMTP/  s^(set smtp_pass=).*^#\1^ " $target_file 
  fi

  zenity --question --text="Do you use PGP?"
  if [ $? = 0 ] ;then
    key=$(zenity --entry --title "PGP key ID" --text "Enter your PGP Key ID  0x....." )
  else
    sed -i -E "/PGP/,/END PGP/  s/^(set pgp_sign_as=).*/#\1/ " $target_file 
  fi
  if [ "x$key" != "x" ]; then
    sed -i -E "/PGP/,/END PGP/  s^.*(set pgp_sign_as=).*^\1$key^ " $target_file 
  fi
  if [ $configured != 1 ];then
    sed -i '1 i ##CONFIGURED '  $target_file
  fi
  exit
else
  zenity --error --text="You need those details to set up mutt."
  exit
fi
